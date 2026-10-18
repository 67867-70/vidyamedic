<?php
/**
 * VidyaMedic AI - REST API Endpoint (Dual Engine: Groq AI & Google Gemini)
 * Lokasi Server: barajacoffee.com/vidya/api.php
 * 
 * Melayani aplikasi Flutter untuk sinkronisasi konfigurasi persona
 * dan proxy chat aman ke Groq AI (Llama 3.3) atau Google Gemini API tanpa mengekspos API Key ke sisi client.
 */

// Konfigurasi Header CORS & JSON
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('Content-Type: application/json; charset=UTF-8');

// Tangani Preflight Request
if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$configFile = __DIR__ . '/config.json';

// Helper Baca Konfigurasi
function loadConfig($file) {
    if (!file_exists($file)) {
        return [
            'ai_provider' => 'groq',
            'groq_api_key' => '',
            'groq_model' => 'llama-3.3-70b-versatile',
            'gemini_api_key' => '',
            'gemini_model' => 'gemini-1.5-flash',
            'temperature' => 0.7,
            'max_tokens' => 1024,
            'persona' => [
                'name' => 'Dr. Vidya',
                'title' => 'Dokter Spesialis Pendamping & Telemedis',
                'greeting' => 'Halo! Saya Dr. Vidya. Ada yang bisa saya bantu terkait kesehatan jantung dan fisiologis Anda hari ini?',
                'system_instruction' => 'Anda adalah Dr. Vidya, dokter telemedis ramah dan teliti di aplikasi VidyaMedic.',
                'quick_prompts' => ['Apa arti detak jantung 110 bpm saat duduk?', 'Tips menjaga HRV stabil']
            ]
        ];
    }
    $raw = file_get_contents($file);
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}

$config = loadConfig($configFile);
$action = isset($_GET['action']) ? trim($_GET['action']) : '';

// Baca body JSON jika ada
$rawInput = file_get_contents('php://input');
$inputData = json_decode($rawInput, true) ?? [];

switch ($action) {
    case 'ping':
        echo json_encode([
            'status' => 'success',
            'message' => 'VidyaMedic AI Backend Active',
            'server' => 'barajacoffee.com/vidya',
            'timestamp' => date('Y-m-d H:i:s')
        ]);
        break;

    case 'config':
        // Kembalikan konfigurasi publik persona (API Key dirahasiakan untuk keamanan)
        $provider = $config['ai_provider'] ?? 'groq';
        $activeKey = ($provider === 'groq') 
            ? ($config['groq_api_key'] ?? '') 
            : ($config['gemini_api_key'] ?? '');
        $activeModel = ($provider === 'groq') 
            ? ($config['groq_model'] ?? 'llama-3.3-70b-versatile') 
            : ($config['gemini_model'] ?? 'gemini-1.5-flash');

        echo json_encode([
            'status' => 'success',
            'server_version' => '1.1.0',
            'ai_provider' => $provider,
            'last_updated' => $config['last_updated'] ?? date('Y-m-d H:i:s'),
            'has_api_key' => !empty($activeKey),
            'gemini_model' => $activeModel, // Backward-compat key for Flutter client
            'active_model' => $activeModel,
            'persona' => $config['persona'] ?? [
                'name' => 'Dr. Vidya',
                'title' => 'Dokter Spesialis Pendamping VidyaMedic',
                'greeting' => 'Halo! Saya Dr. Vidya.',
                'quick_prompts' => []
            ]
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        break;

    case 'chat':
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(405);
            echo json_encode(['status' => 'error', 'message' => 'Gunakan metode POST untuk endpoint chat']);
            exit;
        }

        $provider = $config['ai_provider'] ?? 'groq';
        $groqKey = trim($config['groq_api_key'] ?? '');
        $geminiKey = trim($config['gemini_api_key'] ?? '');

        // Auto-detect jika key hanya diisi di salah satu
        if (!empty($groqKey) && empty($geminiKey)) {
            $provider = 'groq';
        } elseif (!empty($geminiKey) && empty($groqKey)) {
            $provider = 'gemini';
        }

        $apiKey = ($provider === 'groq') ? $groqKey : $geminiKey;
        $model = ($provider === 'groq') 
            ? trim($config['groq_model'] ?? 'llama-3.3-70b-versatile') 
            : trim($config['gemini_model'] ?? 'gemini-1.5-flash');

        $userMessage = trim($inputData['user_message'] ?? $inputData['message'] ?? '');
        $history = $inputData['history'] ?? $inputData['messages'] ?? [];
        $healthContext = $inputData['health_context'] ?? [];

        if (empty($userMessage)) {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Pesan pengguna (user_message) tidak boleh kosong']);
            exit;
        }

        // Jika API Key belum diset di portal web, berikan fallback respons cerdas
        if (empty($apiKey)) {
            $doctorName = $config['persona']['name'] ?? 'Dr. Vidya';
            $simulated = "Halo! Saya $doctorName. Server saat ini dalam mode asisten bawaan karena API Key AI belum diisi di portal web (barajacoffee.com/vidya).\n\n"
                       . "Mengenai pertanyaan Anda (\"$userMessage\"), jika Anda merasakan detak jantung tidak wajar atau palpitasi, pastikan untuk beristirahat duduk tenang selama 5-10 menit. Lakukan teknik pernapasan 4-7-8 untuk menenangkan sistem saraf otonom.";
            echo json_encode([
                'status' => 'success',
                'mode' => 'simulated_no_key',
                'reply' => $simulated,
                'doctor_name' => $doctorName,
                'model' => 'offline-fallback'
            ]);
            exit;
        }

        // Susun prompt persona & konteks kesehatan pasien
        $systemText = $config['persona']['system_instruction'] ?? 'Anda adalah Dr. Vidya, dokter ramah pendamping telemedis VidyaMedic.';
        if (!empty($healthContext) && is_array($healthContext)) {
            $systemText .= "\n\n[DATA FISIOLOGIS REAL-TIME PASIEN]:\n";
            foreach ($healthContext as $k => $v) {
                $systemText .= "- " . ucfirst(str_replace('_', ' ', $k)) . ": " . (is_array($v) ? json_encode($v) : $v) . "\n";
            }
        }

        if ($provider === 'groq') {
            // =================================================================
            // 🚀 PROXY KE GROQ AI (Llama 3.3 / Mixtral)
            // =================================================================
            $groqMessages = [];
            $groqMessages[] = ['role' => 'system', 'content' => $systemText];

            if (!empty($history) && is_array($history)) {
                foreach ($history as $h) {
                    $role = (isset($h['sender']) && $h['sender'] === 'ai') ? 'assistant' : 'user';
                    $text = $h['text'] ?? $h['content'] ?? '';
                    if (!empty($text)) {
                        $groqMessages[] = ['role' => $role, 'content' => $text];
                    }
                }
            }
            $groqMessages[] = ['role' => 'user', 'content' => $userMessage];

            $groqPayload = [
                'model' => $model,
                'messages' => $groqMessages,
                'temperature' => (float)($config['temperature'] ?? 0.7),
                'max_tokens' => (int)($config['max_tokens'] ?? 1024)
            ];

            $ch = curl_init('https://api.groq.com/openai/v1/chat/completions');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'Authorization: Bearer ' . $apiKey
            ]);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($groqPayload));
            curl_setopt($ch, CURLOPT_TIMEOUT, 30);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);

            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $curlError = curl_error($ch);
            curl_close($ch);

            if ($curlError) {
                http_response_code(502);
                echo json_encode(['status' => 'error', 'message' => 'Gagal menghubungi Groq API: ' . $curlError]);
                exit;
            }

            $resData = json_decode($response, true);
            if ($httpCode >= 200 && $httpCode < 300 && isset($resData['choices'][0]['message']['content'])) {
                $aiText = $resData['choices'][0]['message']['content'];
                echo json_encode([
                    'status' => 'success',
                    'reply' => $aiText,
                    'model' => $model,
                    'provider' => 'groq',
                    'doctor_name' => $config['persona']['name'] ?? 'Dr. Vidya'
                ], JSON_UNESCAPED_UNICODE);
            } else {
                http_response_code(500);
                $errMsg = $resData['error']['message'] ?? 'Respon tidak valid dari Groq API';
                echo json_encode(['status' => 'error', 'message' => $errMsg, 'raw_error' => $resData['error'] ?? null]);
            }
            break;

        } else {
            // =================================================================
            // 🔷 PROXY KE GOOGLE GEMINI API
            // =================================================================
            $contents = [];
            if (!empty($history) && is_array($history)) {
                foreach ($history as $h) {
                    $role = (isset($h['sender']) && $h['sender'] === 'ai') ? 'model' : 'user';
                    $text = $h['text'] ?? $h['content'] ?? '';
                    if (!empty($text)) {
                        $contents[] = ['role' => $role, 'parts' => [['text' => $text]]];
                    }
                }
            }
            $contents[] = ['role' => 'user', 'parts' => [['text' => $userMessage]]];

            $payload = [
                'contents' => $contents,
                'systemInstruction' => ['parts' => [['text' => $systemText]]],
                'generationConfig' => [
                    'temperature' => (float)($config['temperature'] ?? 0.7),
                    'maxOutputTokens' => (int)($config['max_tokens'] ?? 1024)
                ]
            ];

            $url = "https://generativelanguage.googleapis.com/v1beta/models/{$model}:generateContent?key={$apiKey}";
            $ch = curl_init($url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'x-goog-api-key: ' . $apiKey
            ]);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
            curl_setopt($ch, CURLOPT_TIMEOUT, 30);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);

            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $curlError = curl_error($ch);
            curl_close($ch);

            if ($curlError) {
                http_response_code(502);
                echo json_encode(['status' => 'error', 'message' => 'Gagal menghubungi Gemini API: ' . $curlError]);
                exit;
            }

            $resData = json_decode($response, true);
            if ($httpCode >= 200 && $httpCode < 300 && isset($resData['candidates'][0]['content']['parts'][0]['text'])) {
                $aiText = $resData['candidates'][0]['content']['parts'][0]['text'];
                echo json_encode([
                    'status' => 'success',
                    'reply' => $aiText,
                    'model' => $model,
                    'provider' => 'gemini',
                    'doctor_name' => $config['persona']['name'] ?? 'Dr. Vidya'
                ], JSON_UNESCAPED_UNICODE);
            } else {
                http_response_code(500);
                $errMsg = $resData['error']['message'] ?? 'Respon tidak valid dari Google Gemini API';
                echo json_encode(['status' => 'error', 'message' => $errMsg, 'raw_error' => $resData['error'] ?? null]);
            }
            break;
        }

    case 'test_connection':
        // Uji koneksi cepat
        $reqProvider = $inputData['provider'] ?? $config['ai_provider'] ?? 'groq';
        $testKey = !empty($inputData['api_key']) ? trim($inputData['api_key']) : '';
        
        // Auto-detect provider dari format prefix kunci
        if (strpos($testKey, 'gsk_') === 0) {
            $reqProvider = 'groq';
        } elseif (strpos($testKey, 'AIza') === 0 || strpos($testKey, 'AQ.') === 0) {
            $reqProvider = 'gemini';
        }

        if (empty($testKey)) {
            $testKey = ($reqProvider === 'groq') 
                ? trim($config['groq_api_key'] ?? '') 
                : trim($config['gemini_api_key'] ?? '');
        }

        if (empty($testKey)) {
            echo json_encode(['status' => 'error', 'message' => 'API Key belum diisi']);
            exit;
        }

        if ($reqProvider === 'groq') {
            // Uji Groq
            $testModel = !empty($inputData['model']) ? trim($inputData['model']) : 'llama-3.3-70b-versatile';
            $groqTestPayload = [
                'model' => $testModel,
                'messages' => [
                    ['role' => 'user', 'content' => 'Halo, tes koneksi 1 kata saja: Siap']
                ],
                'max_tokens' => 10
            ];

            $ch = curl_init('https://api.groq.com/openai/v1/chat/completions');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'Authorization: Bearer ' . $testKey
            ]);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($groqTestPayload));
            curl_setopt($ch, CURLOPT_TIMEOUT, 15);
            $testRes = curl_exec($ch);
            $testCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $testErr = curl_error($ch);
            curl_close($ch);

            if ($testErr) {
                echo json_encode(['status' => 'error', 'message' => 'Curl Error Groq: ' . $testErr]);
                exit;
            }

            $resParsed = json_decode($testRes, true);
            if ($testCode === 200 && isset($resParsed['choices'][0]['message']['content'])) {
                echo json_encode([
                    'status' => 'success',
                    'provider' => 'groq',
                    'message' => 'Koneksi ke Groq AI (' . $testModel . ') Berhasil!',
                    'sample_response' => trim($resParsed['choices'][0]['message']['content'])
                ]);
            } else {
                // Ambil daftar model aktif langsung dari akun Groq pengguna
                $mCh = curl_init('https://api.groq.com/openai/v1/models');
                curl_setopt($mCh, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($mCh, CURLOPT_HTTPHEADER, ['Authorization: Bearer ' . $testKey]);
                curl_setopt($mCh, CURLOPT_TIMEOUT, 10);
                $mRes = curl_exec($mCh);
                curl_close($mCh);
                $mData = json_decode($mRes, true);
                $availableModels = [];
                if (!empty($mData['data']) && is_array($mData['data'])) {
                    foreach ($mData['data'] as $dm) {
                        $mId = $dm['id'] ?? '';
                        if ($mId && strpos($mId, 'whisper') === false && strpos($mId, 'tts') === false) {
                            $availableModels[] = $mId;
                        }
                    }
                }

                echo json_encode([
                    'status' => 'error',
                    'message' => $resParsed['error']['message'] ?? 'Model Groq tidak valid (HTTP ' . $testCode . ')',
                    'available_models' => $availableModels
                ]);
            }
        } else {
            // Uji Gemini
            $testModel = !empty($inputData['model']) ? trim($inputData['model']) : 'gemini-1.5-flash';
            $testPayload = [
                'contents' => [
                    ['role' => 'user', 'parts' => [['text' => 'Halo, tes koneksi 1 kata saja: Siap']]]
                ]
            ];

            $testUrl = "https://generativelanguage.googleapis.com/v1beta/models/{$testModel}:generateContent?key={$testKey}";
            $ch = curl_init($testUrl);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/json',
                'x-goog-api-key: ' . $testKey
            ]);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($testPayload));
            curl_setopt($ch, CURLOPT_TIMEOUT, 15);
            $testRes = curl_exec($ch);
            $testCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $testErr = curl_error($ch);
            curl_close($ch);

            if ($testErr) {
                echo json_encode(['status' => 'error', 'message' => 'Curl Error Gemini: ' . $testErr]);
                exit;
            }

            $resParsed = json_decode($testRes, true);
            if ($testCode === 200 && isset($resParsed['candidates'][0]['content']['parts'][0]['text'])) {
                echo json_encode([
                    'status' => 'success',
                    'provider' => 'gemini',
                    'message' => 'Koneksi ke Google Gemini Berhasil!',
                    'sample_response' => trim($resParsed['candidates'][0]['content']['parts'][0]['text'])
                ]);
            } else {
                echo json_encode([
                    'status' => 'error',
                    'message' => $resParsed['error']['message'] ?? 'API Key atau Model salah (HTTP ' . $testCode . ')'
                ]);
            }
        }
        break;

    case 'list_models':
        $key = !empty($inputData['api_key']) ? trim($inputData['api_key']) : trim($config['groq_api_key'] ?? '');
        $ch = curl_init('https://api.groq.com/openai/v1/models');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $key
        ]);
        $res = curl_exec($ch);
        curl_close($ch);
        echo $res;
        break;

    default:
        echo json_encode([
            'status' => 'error',
            'message' => 'Action tidak dikenal. Gunakan ?action=config, ?action=chat, atau ?action=ping'
        ]);
        break;
}
