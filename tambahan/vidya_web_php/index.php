<?php
/**
 * VidyaMedic AI - Web Admin Dashboard
 * URL: https://barajacoffee.com/vidya/
 * 
 * Panel web untuk mengelola Google Gemini API Key, Model AI,
 * dan Persona Dokter (Dr. Vidya) secara terpusat dari luar aplikasi mobile.
 */

session_start();

$configFile = __DIR__ . '/config.json';

// Baca konfigurasi saat ini
function getConfig($file) {
    if (!file_exists($file)) {
        return [
            'admin_pin' => '1234',
            'gemini_api_key' => '',
            'gemini_model' => 'gemini-1.5-flash',
            'temperature' => 0.7,
            'max_tokens' => 1024,
            'persona' => [
                'name' => 'Dr. Vidya',
                'title' => 'Dokter Spesialis Pendamping & Telemedis VidyaMedic',
                'greeting' => 'Halo! Saya Dr. Vidya, dokter pendamping virtual Anda di VidyaMedic. Bagaimana kondisi detak jantung Anda hari ini?',
                'quick_prompts' => [
                    'Bagaimana cara membaca grafik detak jantung saya?',
                    'Kapan saya harus segera ke IGD jika dada berdebar?',
                    'Tips menjaga variabilitas detak jantung (HRV) tetap baik'
                ],
                'system_instruction' => 'Anda adalah Dr. Vidya, dokter pendamping telemedis cerdas pada aplikasi kesehatan VidyaMedic.\nBahasa ramah, empati, dan utamakan keselamatan pasien.'
            ],
            'last_updated' => date('Y-m-d H:i:s')
        ];
    }
    $raw = file_get_contents($file);
    return json_decode($raw, true) ?? [];
}

function saveConfig($file, $data) {
    $data['last_updated'] = date('Y-m-d H:i:s');
    return file_put_contents($file, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE));
}

$config = getConfig($configFile);
$adminPin = $config['admin_pin'] ?? '1234';

// Handle Logout
if (isset($_GET['logout'])) {
    unset($_SESSION['vidya_logged_in']);
    header('Location: index.php');
    exit;
}

// Handle Login
$loginError = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'login') {
    $inputPin = trim($_POST['pin'] ?? '');
    if ($inputPin === $adminPin) {
        $_SESSION['vidya_logged_in'] = true;
        header('Location: index.php');
        exit;
    } else {
        $loginError = 'PIN Administrator salah. Silakan coba lagi.';
    }
}

// Handle Save Configuration
$saveMessage = '';
$saveError = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'save_settings' && !empty($_SESSION['vidya_logged_in'])) {
    $provider = trim($_POST['ai_provider'] ?? 'groq');
    $groqKey = trim($_POST['groq_api_key'] ?? '');
    $groqModel = trim($_POST['groq_model'] ?? 'llama-3.3-70b-versatile');
    $geminiKey = trim($_POST['gemini_api_key'] ?? '');
    $geminiModel = trim($_POST['gemini_model'] ?? 'gemini-1.5-flash');
    $temp = floatval($_POST['temperature'] ?? 0.7);
    $maxTokens = intval($_POST['max_tokens'] ?? 1024);
    $newPin = trim($_POST['admin_pin'] ?? '');

    $docName = trim($_POST['persona_name'] ?? 'Dr. Vidya');
    $docTitle = trim($_POST['persona_title'] ?? '');
    $greeting = trim($_POST['persona_greeting'] ?? '');
    $sysPrompt = trim($_POST['persona_prompt'] ?? '');

    // Prompts cepat (pecah per baris)
    $quickRaw = trim($_POST['quick_prompts'] ?? '');
    $quickList = array_values(array_filter(array_map('trim', explode("\n", $quickRaw))));

    $config['ai_provider'] = $provider;
    $config['groq_api_key'] = $groqKey;
    $config['groq_model'] = $groqModel;
    $config['gemini_api_key'] = $geminiKey;
    $config['gemini_model'] = $geminiModel;
    $config['temperature'] = $temp;
    $config['max_tokens'] = $maxTokens;
    if (!empty($newPin)) {
        $config['admin_pin'] = $newPin;
    }

    $config['persona']['name'] = $docName;
    $config['persona']['title'] = $docTitle;
    $config['persona']['greeting'] = $greeting;
    $config['persona']['system_instruction'] = $sysPrompt;
    $config['persona']['quick_prompts'] = $quickList;
    $config['last_updated'] = date('Y-m-d H:i:s');

    if (saveConfig($configFile, $config)) {
        $providerName = ($provider === 'groq') ? 'Groq AI (Llama 3.3)' : 'Google Gemini';
        $saveMessage = "Pengaturan Provider $providerName & Persona berhasil disimpan! Aplikasi Flutter akan langsung menyinkronkan data ini.";
    } else {
        $saveError = 'Gagal menyimpan file config.json. Pastikan folder memiliki hak akses tulis (chmod 755 atau 777).';
    }
}

$isLoggedIn = !empty($_SESSION['vidya_logged_in']);
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VidyaMedic AI Admin Portal | barajacoffee.com/vidya</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #00838F;
            --primary-dark: #006064;
            --primary-light: #E0F7FA;
            --accent: #FF7043;
            --bg: #F4F7F9;
            --card-bg: #FFFFFF;
            --text-dark: #1E293B;
            --text-muted: #64748B;
            --border: #E2E8F0;
            --success: #10B981;
            --danger: #EF4444;
            --warning: #F59E0B;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        body {
            background-color: var(--bg);
            color: var(--text-dark);
            min-height: 100vh;
            padding-bottom: 60px;
        }

        /* Top Navigation Bar */
        .topbar {
            background: #ffffff;
            border-bottom: 1px solid var(--border);
            padding: 16px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }

        .brand-container {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: #ffffff;
            box-shadow: 0 4px 10px rgba(0, 131, 143, 0.3);
        }

        .brand-text h1 {
            font-size: 18px;
            font-weight: 800;
            color: var(--primary-dark);
            letter-spacing: -0.3px;
        }

        .brand-text p {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 500;
        }

        .server-badge {
            background: var(--primary-light);
            color: var(--primary-dark);
            font-size: 11px;
            font-weight: 700;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .server-dot {
            width: 8px;
            height: 8px;
            background: var(--success);
            border-radius: 50%;
            display: inline-block;
            box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
        }

        /* Container Layout */
        .container {
            max-width: 1000px;
            margin: 28px auto;
            padding: 0 20px;
        }

        /* Login Card */
        .login-card {
            max-width: 420px;
            margin: 80px auto;
            background: var(--card-bg);
            border-radius: 20px;
            padding: 36px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border: 1px solid var(--border);
            text-align: center;
        }

        .login-card h2 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .login-card p {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 24px;
        }

        /* Notification Badges */
        .alert {
            padding: 14px 18px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success { background: #DCFCE7; color: #166534; border: 1px solid #BBF7D0; }
        .alert-danger { background: #FEE2E2; color: #991B1B; border: 1px solid #FECACA; }

        /* Tabs */
        .tabs-header {
            display: flex;
            gap: 8px;
            border-bottom: 2px solid var(--border);
            margin-bottom: 24px;
            overflow-x: auto;
        }

        .tab-btn {
            background: none;
            border: none;
            padding: 12px 18px;
            font-size: 14px;
            font-weight: 700;
            color: var(--text-muted);
            cursor: pointer;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .tab-btn:hover {
            color: var(--primary);
        }

        .tab-btn.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
        }

        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }

        /* Card Section */
        .card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }

        .card-header {
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Form Controls */
        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 6px;
        }

        .form-hint {
            font-size: 11px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        input[type="text"],
        input[type="password"],
        select,
        textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 13px;
            outline: none;
            transition: border-color 0.2s;
            background: #FAFAFA;
        }

        input:focus, select:focus, textarea:focus {
            border-color: var(--primary);
            background: #FFFFFF;
            box-shadow: 0 0 0 3px rgba(0, 131, 143, 0.1);
        }

        textarea {
            font-family: 'JetBrains Mono', monospace;
            font-size: 12px;
            line-height: 1.6;
            resize: vertical;
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        @media (max-width: 768px) {
            .grid-2 {
                grid-template-columns: 1fr;
            }
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 22px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
        }

        .btn-primary {
            background: var(--primary);
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 131, 143, 0.25);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #F1F5F9;
            color: #475569;
            border: 1px solid #CBD5E1;
        }

        .btn-secondary:hover {
            background: #E2E8F0;
        }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--primary);
            color: var(--primary);
        }

        .btn-outline:hover {
            background: var(--primary-light);
        }

        /* Preset Pills */
        .preset-container {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }

        .preset-chip {
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background: #F8FAFC;
            border: 1px solid var(--border);
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .preset-chip:hover {
            border-color: var(--primary);
            background: var(--primary-light);
            color: var(--primary-dark);
        }

        /* Chat Test Box */
        .chat-box {
            background: #F8FAFC;
            border: 1px solid var(--border);
            border-radius: 12px;
            height: 380px;
            overflow-y: auto;
            padding: 16px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 14px;
        }

        .chat-bubble {
            max-width: 80%;
            padding: 12px 16px;
            border-radius: 14px;
            font-size: 13px;
            line-height: 1.5;
        }

        .bubble-ai {
            align-self: flex-start;
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            color: #1E293B;
            border-bottom-left-radius: 2px;
        }

        .bubble-user {
            align-self: flex-end;
            background: var(--primary);
            color: #FFFFFF;
            border-bottom-right-radius: 2px;
        }

        .chat-input-bar {
            display: flex;
            gap: 10px;
        }

        /* Code block snippet */
        .code-box {
            background: #0F172A;
            color: #F8FAFC;
            font-family: 'JetBrains Mono', monospace;
            font-size: 12px;
            padding: 14px;
            border-radius: 10px;
            overflow-x: auto;
            line-height: 1.5;
        }
    </style>
</head>
<body>

<!-- Top Navigation -->
<header class="topbar">
    <div class="brand-container">
        <div class="brand-icon">🩺</div>
        <div class="brand-text">
            <h1>VidyaMedic AI Portal</h1>
            <p>barajacoffee.com/vidya &bull; Pengaturan Terpusat Chatbot & Persona</p>
        </div>
    </div>
    <div style="display: flex; align-items: center; gap: 14px;">
        <div class="server-badge">
            <span class="server-dot"></span>
            Server Siap &bull; v1.0.0
        </div>
        <?php if ($isLoggedIn): ?>
            <a href="index.php?logout=1" class="btn btn-secondary" style="padding: 6px 14px; font-size: 12px;">Keluar</a>
        <?php endif; ?>
    </div>
</header>

<main class="container">

<?php if (!$isLoggedIn): ?>
    <!-- Halaman Login PIN Admin -->
    <div class="login-card">
        <div style="font-size: 40px; margin-bottom: 12px;">🔒</div>
        <h2>Akses Pengaturan VidyaMedic</h2>
        <p>Silakan masukkan PIN Administrator untuk mengatur API Key Gemini dan Persona Dr. Vidya.</p>

        <?php if (!empty($loginError)): ?>
            <div class="alert alert-danger"><?= htmlspecialchars($loginError) ?></div>
        <?php endif; ?>

        <form method="POST">
            <input type="hidden" name="action" value="login">
            <div class="form-group" style="text-align: left;">
                <label>PIN Administrator</label>
                <input type="password" name="pin" placeholder="Default PIN: 1234" autofocus required style="text-align: center; font-size: 18px; letter-spacing: 4px;">
                <div class="form-hint" style="text-align: center;">Default PIN bawaan: <code>1234</code></div>
            </div>
            <button type="submit" class="btn btn-primary" style="width: 100%;">Buka Dashboard</button>
        </form>
    </div>

<?php else: ?>

    <!-- Tampilkan Notifikasi Sukses / Gagal Simpan -->
    <?php if (!empty($saveMessage)): ?>
        <div class="alert alert-success">✅ <?= htmlspecialchars($saveMessage) ?></div>
    <?php endif; ?>
    <?php if (!empty($saveError)): ?>
        <div class="alert alert-danger">⚠️ <?= htmlspecialchars($saveError) ?></div>
    <?php endif; ?>

    <!-- Navigasi Tab -->
    <div class="tabs-header">
        <button class="tab-btn active" onclick="switchTab('tab-persona', this)">🩺 Persona & Dokter</button>
        <button class="tab-btn" onclick="switchTab('tab-gemini', this)">🔑 Provider AI & Model</button>
        <button class="tab-btn" onclick="switchTab('tab-chat-test', this)">💬 Uji Coba Chat Langsung</button>
        <button class="tab-btn" onclick="switchTab('tab-api-info', this)">📡 Endpoint Aplikasi</button>
    </div>

    <form method="POST" id="mainForm">
        <input type="hidden" name="action" value="save_settings">

        <!-- TAB 1: PERSONA & DOKTER -->
        <div id="tab-persona" class="tab-content active">
            <div class="card">
                <div class="card-header">
                    <div class="card-title">🩺 Profil Dokter & Persona AI</div>
                    <span style="font-size: 12px; color: var(--text-muted);">Pembaruan terakhir: <?= htmlspecialchars($config['last_updated'] ?? '-') ?></span>
                </div>

                <div class="preset-container">
                    <span style="font-size: 12px; font-weight: 700; color: #475569; align-self: center;">Pilih Preset Cepat:</span>
                    <button type="button" class="preset-chip" onclick="applyPreset('dokter_ramah')">🩺 Dr. Vidya (Dokter Ramah)</button>
                    <button type="button" class="preset-chip" onclick="applyPreset('konsultan_kebugaran')">🏃 Konsultan Kebugaran</button>
                    <button type="button" class="preset-chip" onclick="applyPreset('analis_klinis')">📊 Analis Medis Ringkas</button>
                </div>

                <div class="grid-2">
                    <div class="form-group">
                        <label>Nama Dokter / Asisten AI</label>
                        <input type="text" id="persona_name" name="persona_name" value="<?= htmlspecialchars($config['persona']['name'] ?? 'Dr. Vidya') ?>" required>
                    </div>
                    <div class="form-group">
                        <label>Gelar / Sub-Judul Spesialisasi</label>
                        <input type="text" id="persona_title" name="persona_title" value="<?= htmlspecialchars($config['persona']['title'] ?? 'Dokter Spesialis Pendamping VidyaMedic') ?>">
                    </div>
                </div>

                <div class="form-group">
                    <label>Pesan Sambutan Pembuka (Greeting Message)</label>
                    <textarea id="persona_greeting" name="persona_greeting" rows="2"><?= htmlspecialchars($config['persona']['greeting'] ?? '') ?></textarea>
                    <div class="form-hint">Pesan yang langsung muncul di aplikasi saat pengguna pertama kali membuka tab Chatbot.</div>
                </div>

                <div class="form-group">
                    <label>Instruksi Sistem Medis (System Prompt / Persona AI)</label>
                    <textarea id="persona_prompt" name="persona_prompt" rows="8" style="font-size: 13px;"><?= htmlspecialchars($config['persona']['system_instruction'] ?? '') ?></textarea>
                    <div class="form-hint">Aturan gaya bicara, batasan diagnosis klinis, protokol darurat nyeri dada, dan etika telemedis yang dipatuhi oleh Gemini.</div>
                </div>

                <div class="form-group">
                    <label>Saran Pertanyaan Cepat (Quick Prompts di Aplikasi)</label>
                    <?php
                        $promptsText = implode("\n", $config['persona']['quick_prompts'] ?? []);
                    ?>
                    <textarea name="quick_prompts" rows="3" placeholder="Satu pertanyaan per baris"><?= htmlspecialchars($promptsText) ?></textarea>
                    <div class="form-hint">Tulis 1 saran pertanyaan per baris. Akan ditampilkan sebagai tombol chip di aplikasi Flutter.</div>
                </div>
            </div>
        </div>

        <!-- TAB 2: AI PROVIDER & MODEL -->
        <div id="tab-gemini" class="tab-content">
            <div class="card">
                <div class="card-header">
                    <div class="card-title">🔑 Pengaturan AI Provider & Model</div>
                    <div>
                        <?php 
                            $curProv = $config['ai_provider'] ?? 'groq';
                            $hasActiveKey = ($curProv === 'groq') ? !empty($config['groq_api_key']) : !empty($config['gemini_api_key']);
                            if ($hasActiveKey): 
                        ?>
                            <span style="background: #DCFCE7; color: #166534; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 700;">API Key Tersedia (<?= strtoupper($curProv) ?>)</span>
                        <?php else: ?>
                            <span style="background: #FEE2E2; color: #991B1B; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 700;">Belum Ada API Key</span>
                        <?php endif; ?>
                    </div>
                </div>

                <!-- Provider Selector -->
                <div class="form-group">
                    <label style="font-weight: 800; font-size: 13.5px;">Pilih Provider Mesin AI</label>
                    <select name="ai_provider" id="ai_provider" onchange="toggleProviderView(this.value)" style="border: 2px solid var(--primary); font-weight: 700; background: #F0FDF4;">
                        <option value="groq" <?= (($config['ai_provider'] ?? 'groq') === 'groq') ? 'selected' : '' ?>>🚀 Groq AI (Llama 3.3 70B) — Gratis, Cepat & Bebas Blokir Google</option>
                        <option value="gemini" <?= (($config['ai_provider'] ?? '') === 'gemini') ? 'selected' : '' ?>>🔷 Google Gemini API (1.5 Flash / Pro)</option>
                    </select>
                    <div class="form-hint" style="color: #0F766E; font-weight: 600;">Sangat Direkomendasikan: <strong>Groq AI</strong> 100% gratis, respons super cepat (500 kata/detik), dan tidak terikat Google Cloud.</div>
                </div>

                <!-- SECTION GROQ -->
                <div id="section-groq" style="<?= (($config['ai_provider'] ?? 'groq') === 'groq') ? 'display:block;' : 'display:none;' ?>">
                    <div class="form-group">
                        <label>Groq API Key</label>
                        <div style="position: relative;">
                            <input type="password" id="groq_api_key" name="groq_api_key" value="<?= htmlspecialchars($config['groq_api_key'] ?? '') ?>" placeholder="gsk_...">
                            <button type="button" onclick="togglePassword('groq_api_key')" style="position: absolute; right: 10px; top: 10px; background: none; border: none; cursor: pointer; font-size: 14px;">👁️</button>
                        </div>
                        <div class="form-hint">Dapatkan gratis dalam 10 detik dari 👉 <a href="https://console.groq.com/keys" target="_blank" style="color: var(--primary); font-weight: 700; text-decoration: underline;">console.groq.com/keys</a> (Daftar/login dengan email apa saja, klik "Create API Key" tanpa kartu kredit).</div>
                    </div>

                    <div class="form-group">
                        <div style="display: flex; align-items: center; justify-content: space-between;">
                            <label style="margin-bottom: 0;">Model Groq</label>
                            <button type="button" class="btn btn-secondary" onclick="fetchGroqModels()" style="padding: 3px 10px; font-size: 11px;">🔄 Cek Model Aktif Akun Saya</button>
                        </div>
                        <select name="groq_model" id="groq_model" style="margin-top: 6px;">
                            <?php 
                                $groqModels = [
                                    'llama-3.3-70b-versatile' => 'llama-3.3-70b-versatile (Paling Cerdas, Sangat Direkomendasikan)',
                                    'llama-3.1-8b-instant' => 'llama-3.1-8b-instant (Super Kilat & Ringan)',
                                    'llama3-70b-8192' => 'llama3-70b-8192 (Llama 3 70B Stable)',
                                    'llama3-8b-8192' => 'llama3-8b-8192 (Llama 3 8B Stable)',
                                    'gemma2-9b-it' => 'gemma2-9b-it (Google Gemma 2 via Groq)'
                                ];
                                $curGroqModel = $config['groq_model'] ?? 'llama-3.3-70b-versatile';
                                foreach ($groqModels as $mVal => $mLabel) {
                                    $sel = ($mVal === $curGroqModel) ? 'selected' : '';
                                    echo "<option value=\"$mVal\" $sel>$mLabel</option>";
                                }
                            ?>
                        </select>
                        <div class="form-hint">Rekomendasi terbaik: <strong>llama-3.3-70b-versatile</strong> atau <strong>llama-3.1-8b-instant</strong>.</div>
                    </div>
                </div>

                <!-- SECTION GEMINI -->
                <div id="section-gemini" style="<?= (($config['ai_provider'] ?? 'groq') === 'gemini') ? 'display:block;' : 'display:none;' ?>">
                    <div class="form-group">
                        <label>Google Gemini API Key</label>
                        <div style="position: relative;">
                            <input type="password" id="gemini_api_key" name="gemini_api_key" value="<?= htmlspecialchars($config['gemini_api_key'] ?? '') ?>" placeholder="AIzaSy...">
                            <button type="button" onclick="togglePassword('gemini_api_key')" style="position: absolute; right: 10px; top: 10px; background: none; border: none; cursor: pointer; font-size: 14px;">👁️</button>
                        </div>
                        <div class="form-hint">Dapatkan dari <a href="https://aistudio.google.com/app/apikey" target="_blank" style="color: var(--primary); font-weight: 600;">Google AI Studio</a>.</div>
                    </div>

                    <div class="form-group">
                        <label>Model Gemini</label>
                        <select name="gemini_model" id="gemini_model">
                            <?php 
                                $models = [
                                    'gemini-1.5-flash' => 'gemini-1.5-flash (Cepat, Hemat)',
                                    'gemini-1.5-pro' => 'gemini-1.5-pro (Penalaran Klinis Tinggi)',
                                    'gemini-2.0-flash' => 'gemini-2.0-flash (Eksperimental Generasi Baru)'
                                ];
                                $curModel = $config['gemini_model'] ?? 'gemini-1.5-flash';
                                foreach ($models as $mVal => $mLabel) {
                                    $sel = ($mVal === $curModel) ? 'selected' : '';
                                    echo "<option value=\"$mVal\" $sel>$mLabel</option>";
                                }
                            ?>
                        </select>
                    </div>
                </div>

                <div class="grid-2">
                    <div class="form-group">
                        <label>Kreativitas Jawaban (Temperature: <span id="temp-val"><?= $config['temperature'] ?? 0.7 ?></span>)</label>
                        <input type="range" name="temperature" min="0" max="1" step="0.1" value="<?= $config['temperature'] ?? 0.7 ?>" oninput="document.getElementById('temp-val').innerText = this.value" style="width: 100%; margin-top: 10px;">
                        <div class="form-hint">0.2: Sangat baku & klinis | 0.7: Seimbang & ramah | 1.0: Sangat kreatif</div>
                    </div>
                    <div class="form-group">
                        <label>Max Output Tokens</label>
                        <input type="number" name="max_tokens" value="<?= intval($config['max_tokens'] ?? 1024) ?>">
                    </div>
                </div>

                <div class="form-group">
                    <label>Ganti PIN Administrator</label>
                    <input type="text" name="admin_pin" value="<?= htmlspecialchars($config['admin_pin'] ?? '1234') ?>" placeholder="PIN Baru" style="max-width: 250px;">
                </div>

                <div style="margin-top: 14px;">
                    <button type="button" class="btn btn-outline" onclick="testConnection()">⚡ Uji Koneksi AI Sekarang</button>
                    <span id="test-status" style="margin-left: 12px; font-size: 13px; font-weight: 600;"></span>
                </div>
            </div>
        </div>

        <!-- TAB 3: UJI COBA CHAT LANGSUNG -->
        <div id="tab-chat-test" class="tab-content">
            <div class="card">
                <div class="card-header">
                    <div class="card-title">💬 Live Chatbot Sandbox</div>
                    <span style="font-size: 12px; color: var(--text-muted);">Uji respon AI sebelum dilihat pasien di aplikasi</span>
                </div>

                <div class="chat-box" id="webChatBox">
                    <div class="chat-bubble bubble-ai">
                        <strong><?= htmlspecialchars($config['persona']['name'] ?? 'Dr. Vidya') ?>:</strong><br>
                        <?= nl2br(htmlspecialchars($config['persona']['greeting'] ?? 'Halo! Ada yang bisa saya bantu?')) ?>
                    </div>
                </div>

                <div class="chat-input-bar">
                    <input type="text" id="testMessageInput" placeholder="Ketik pertanyaan medis uji coba (misal: 'Dada saya berdebar 110 bpm')..." onkeypress="if(event.key === 'Enter'){ sendTestChat(); event.preventDefault(); }">
                    <button type="button" class="btn btn-primary" onclick="sendTestChat()">Kirim Pesan</button>
                </div>
            </div>
        </div>

        <!-- TAB 4: API ENDPOINT INFO -->
        <div id="tab-api-info" class="tab-content">
            <div class="card">
                <div class="card-header">
                    <div class="card-title">📡 Integrasi Aplikasi Mobile VidyaMedic</div>
                </div>

                <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 16px;">
                    Aplikasi Flutter VidyaMedic secara otomatis mengambil data persona dan mengirimkan obrolan melalui REST API di server ini:
                </p>

                <div class="form-group">
                    <label>1. Endpoint Sinkronisasi Persona (GET)</label>
                    <div class="code-box">GET https://barajacoffee.com/vidya/api.php?action=config</div>
                </div>

                <div class="form-group">
                    <label>2. Endpoint Chatbot Proxy Aman (POST)</label>
                    <div class="code-box">POST https://barajacoffee.com/vidya/api.php?action=chat
Content-Type: application/json

{
  "user_message": "Bagaimana cara menurunkan detak jantung?",
  "health_context": {
    "heart_rate_bpm": 95,
    "context": "Duduk istirahat"
  }
}</div>
                </div>

                <div style="background: var(--primary-light); padding: 16px; border-radius: 12px; font-size: 13px; color: var(--primary-dark); line-height: 1.6;">
                    🔒 <strong>Keamanan Terjamin:</strong> API Key Google Gemini tetap tersimpan rahasia di server <code>barajacoffee.com</code>. Aplikasi di HP pasien tidak pernah melihat API key aslinya, sehingga aman dari reverse engineering atau pencurian kuota kupon.
                </div>
            </div>
        </div>

        <!-- Action Bar Bawah -->
        <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 10px;">
            <button type="submit" class="btn btn-primary" style="padding: 14px 28px; font-size: 14px;">
                💾 Simpan Semua Pengaturan
            </button>
        </div>
    </form>

<?php endif; ?>

</main>

<script>
function switchTab(tabId, el) {
    document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
    el.classList.add('active');
}

function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    input.type = (input.type === 'password') ? 'text' : 'password';
}

const presets = {
    dokter_ramah: {
        name: "Dr. Vidya",
        title: "Dokter Spesialis Pendamping & Telemedis VidyaMedic",
        greeting: "Halo! Saya Dr. Vidya, dokter pendamping virtual Anda di VidyaMedic. Bagaimana kondisi detak jantung Anda hari ini?",
        prompt: "Anda adalah Dr. Vidya, dokter pendamping telemedis cerdas pada aplikasi kesehatan VidyaMedic.\n\nPrinsip Utama:\n1. Bahasa & Gaya: Gunakan Bahasa Indonesia yang hangat, sopan, empati, dan mudah dimengerti pasien awam.\n2. Analisis Fisiologis: Jelaskan data detak jantung (BPM), HRV, durasi tidur, dan deviasi secara objektif dan menenangkan.\n3. Batasan Klinis: Selalu ingatkan bahwa pemantauan ini adalah preventif, bukan resep atau vonis medis definitif.\n4. Triage Darurat: Jika pasien melaporkan nyeri dada menjalar, sesak napas berat, atau pusing melayang hebat, instruksikan segera ke IGD/119.\n5. Berikan saran praktis: relaksasi pernapasan 4-7-8, minum air, dan posisi istirahat nyaman."
    },
    konsultan_kebugaran: {
        name: "Coach Vidya",
        title: "Konsultan Kebugaran Kardio & Gaya Hidup Aktif",
        greeting: "Semangat! Saya Coach Vidya. Siap mendiskusikan target latihan, pemulihan detak jantung, dan stamina Anda hari ini?",
        prompt: "Anda adalah Coach Vidya, ahli fisiologi olahraga dan konsultan kebugaran kardiovaskular.\n\nGaya Bicara: Enerjik, memotivasi, solutif, dan berbasis data olahraga.\nFokus Utama: Analisis pemulihan detak jantung (heart rate recovery), zona latihan (Zone 2 cardio), hidrasi, kualitas tidur terhadap pemulihan stamina, serta pencegahan overtraining."
    },
    analis_klinis: {
        name: "Vidya Clinical AI",
        title: "Asisten Analisis Data Fisiologis & Triage",
        greeting: "Vidya Clinical AI aktif. Silakan masukkan parameter atau pertanyaan klinis untuk analisis ringkas.",
        prompt: "Anda adalah sistem asisten analisis data fisiologis VidyaMedic.\nGaya: Ringkas, berbasis bukti (evidence-based), terstruktur rapi dengan poin-poin jelas, tanpa basa-basi.\nPrioritaskan klasifikasi risiko detak jantung (Bradikardia, Normal, Takikardia) dan rekomendasi tindakan tindak lanjut medis."
    }
};

function applyPreset(presetKey) {
    const p = presets[presetKey];
    if (!p) return;
    document.getElementById('persona_name').value = p.name;
    document.getElementById('persona_title').value = p.title;
    document.getElementById('persona_greeting').value = p.greeting;
    document.getElementById('persona_prompt').value = p.prompt;
    alert('Preset "' + p.name + '" berhasil dimuat ke formulir! Jangan lupa klik "Simpan Semua Pengaturan" di bagian bawah.');
}

function toggleProviderView(provider) {
    document.getElementById('section-groq').style.display = (provider === 'groq') ? 'block' : 'none';
    document.getElementById('section-gemini').style.display = (provider === 'gemini') ? 'block' : 'none';
}

async function fetchGroqModels() {
    const key = document.getElementById('groq_api_key').value.trim();
    if (!key) {
        alert('Silakan masukkan Groq API Key terlebih dahulu.');
        return;
    }
    const select = document.getElementById('groq_model');
    select.innerHTML = '<option>Sedang memeriksa model aktif...</option>';
    try {
        const res = await fetch('api.php?action=list_models', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ api_key: key })
        });
        const data = await res.json();
        if (data.models && data.models.length > 0) {
            select.innerHTML = '';
            data.models.forEach(m => {
                const opt = document.createElement('option');
                opt.value = m;
                opt.innerText = m;
                if (m === 'llama-3.3-70b-versatile' || m === 'llama-3.1-8b-instant') opt.selected = true;
                select.appendChild(opt);
            });
            alert('✅ Berhasil memuat ' + data.models.length + ' model aktif langsung dari akun Groq Anda!');
        } else {
            alert('Tidak dapat memuat model: ' + (data.error?.message || 'Pastikan API key benar.'));
        }
    } catch (e) {
        alert('Gagal menghubungi api.php: ' + e.message);
    }
}

async function testConnection() {
    const statusEl = document.getElementById('test-status');
    const provider = document.getElementById('ai_provider').value;
    const key = (provider === 'groq') 
        ? document.getElementById('groq_api_key').value.trim()
        : document.getElementById('gemini_api_key').value.trim();
    const model = (provider === 'groq') 
        ? document.getElementById('groq_model').value 
        : document.getElementById('gemini_model').value;

    statusEl.innerHTML = '<span style="color: var(--primary);">⏳ Menghubungi server ' + (provider === 'groq' ? 'Groq AI (' + model + ')' : 'Google Gemini') + '...</span>';

    try {
        const res = await fetch('api.php?action=test_connection', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ provider: provider, api_key: key, model: model })
        });
        const data = await res.json();
        if (data.status === 'success') {
            statusEl.innerHTML = '<span style="color: var(--success);">✅ ' + data.message + ' (Sample: "' + data.sample_response + '")</span>';
        } else {
            let msg = '❌ ' + data.message;
            if (data.available_models && data.available_models.length > 0) {
                const select = document.getElementById('groq_model');
                select.innerHTML = '';
                data.available_models.forEach((m, idx) => {
                    const opt = document.createElement('option');
                    opt.value = m;
                    opt.innerText = m;
                    if (idx === 0) opt.selected = true;
                    select.appendChild(opt);
                });
                msg += '<br><strong>✨ Model aktif yang tersedia di akun Anda otomatis dimasukkan ke dropdown di atas:</strong> ' + data.available_models.slice(0, 5).join(', ') + '<br><em>(Silakan klik tombol "Uji Koneksi AI Sekarang" lagi).</em>';
            }
            statusEl.innerHTML = '<span style="color: var(--danger);">' + msg + '</span>';
        }
    } catch (err) {
        statusEl.innerHTML = '<span style="color: var(--danger);">❌ Gagal fetch API: ' + err.message + '</span>';
    }
}

async function sendTestChat() {
    const input = document.getElementById('testMessageInput');
    const msg = input.value.trim();
    if (!msg) return;

    const chatBox = document.getElementById('webChatBox');
    
    // Bubble User
    const userDiv = document.createElement('div');
    userDiv.className = 'chat-bubble bubble-user';
    userDiv.innerText = msg;
    chatBox.appendChild(userDiv);
    input.value = '';

    // Bubble AI Loading
    const aiDiv = document.createElement('div');
    aiDiv.className = 'chat-bubble bubble-ai';
    aiDiv.innerText = 'Mengetik... ⏳';
    chatBox.appendChild(aiDiv);
    chatBox.scrollTop = chatBox.scrollHeight;

    try {
        const res = await fetch('api.php?action=chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                user_message: msg,
                health_context: {
                    heart_rate_bpm: 110,
                    context: "Duduk santai (Uji Coba Web)"
                }
            })
        });
        const data = await res.json();
        if (data.status === 'success') {
            aiDiv.innerHTML = '<strong>' + (data.doctor_name || 'Dr. Vidya') + ':</strong><br>' + data.reply.replace(/\n/g, '<br>');
        } else {
            aiDiv.innerHTML = '<span style="color: var(--danger);">⚠️ ' + (data.message || 'Error tidak diketahui') + '</span>';
        }
    } catch (e) {
        aiDiv.innerHTML = '<span style="color: var(--danger);">⚠️ Gagal menghubungi api.php: ' + e.message + '</span>';
    }
    chatBox.scrollTop = chatBox.scrollHeight;
}
</script>

</body>
</html>
