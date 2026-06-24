import 'package:fluffy_link/core/page_scaffold.dart';
import 'package:fluffy_link/core/theme.dart';
import 'package:flutter/material.dart';

class DocsScreen extends StatefulWidget {
  const DocsScreen({super.key});

  @override
  State<DocsScreen> createState() => _DocsScreenState();
}

class _DocsScreenState extends State<DocsScreen> {
  int _selectedTopic = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;

    return PageScaffold(
      currentRoute: '/docs',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile)
            Container(
              width: 280,
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: AppTheme.border.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: _DocsSidebar(
                selectedIndex: _selectedTopic,
                onSelect: (index) => setState(() => _selectedTopic = index),
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? AppTheme.spaceLg : AppTheme.space2xl,
                vertical: AppTheme.spaceXl,
              ),
              child: _DocsContent(topic: _selectedTopic),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocsSidebar extends StatelessWidget {
  const _DocsSidebar({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _topics = [
    'Getting Started',
    'Uploading Files',
    'Sharing Links',
    'Analytics',
    'API Reference',
    'FAQ',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documentation',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppTheme.spaceLg),
        for (var index = 0; index < _topics.length; index++)
          _DocLink(
            label: _topics[index],
            isActive: selectedIndex == index,
            onTap: () => onSelect(index),
          ),
      ],
    );
  }
}

class _DocLink extends StatefulWidget {
  const _DocLink({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_DocLink> createState() => _DocLinkState();
}

class _DocLinkState extends State<_DocLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 20,
                color: widget.isActive ? AppTheme.primary : Colors.transparent,
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Expanded(
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.isActive
                        ? AppTheme.primary
                        : (_hovered ? AppTheme.onSurface : AppTheme.muted),
                    fontWeight: widget.isActive
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocsContent extends StatelessWidget {
  const _DocsContent({required this.topic});

  final int topic;

  @override
  Widget build(BuildContext context) {
    switch (topic) {
      case 0:
        return _gettingStartedContent(context);
      case 1:
        return _uploadingFilesContent(context);
      case 2:
        return _sharingLinksContent(context);
      case 3:
        return _analyticsContent(context);
      case 4:
        return _apiReferenceContent(context);
      case 5:
        return _faqContent(context);
      default:
        return const SizedBox.shrink();
    }
  }
}

Widget _gettingStartedContent(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _DocsTitle('Getting Started'),
      _DocSection(
        title: 'What is Perma.link?',
        content:
            'Perma.link is a decentralized file-link service built on top of Walrus, a distributed blob storage network. '
            'You upload a file, Walrus stores it as a content-addressed blob, and Perma.link mints a short URL '
            '(e.g. perma.link/a9k2xQ) that permanently redirects anyone who clicks it to your file.\n\n'
            'Unlike traditional file hosts, the underlying blob lives on a decentralized network — no single company '
            'controls it or can take it down. The short URL lives in Supabase, an open-source Postgres backend, and '
            'the redirect happens in under 200 ms on average.',
      ),
      _DocSection(
        title: 'Quick start',
        content:
            '1. Open the app at /upload (or click "Launch App" on the homepage).\n'
            '2. Drag a file into the drop zone, or click "Browse files" to pick one.\n'
            '3. Wait for the two-phase upload bar to complete (Walrus upload, then link creation).\n'
            '4. Copy your short link from the success card.\n'
            '5. Share it anywhere — the link works forever without an account.',
      ),
      _DocSection(
        title: 'No account required',
        content:
            'Perma.link uses Supabase with anonymous Row Level Security policies. '
            'You never create a username or password. The trade-off is that there is currently no way '
            'to list or manage all links you have created — keep a copy of your short URL after upload. '
            'Your stats page is always accessible at /s/<code> even without an account.',
      ),
      _DocSection(
        title: 'Supported browsers',
        content:
            'Any Chromium-based browser (Chrome, Edge, Brave) and Firefox are fully supported. '
            'Safari 16+ works but may exhibit minor layout differences. '
            'The app is a Flutter Web build, so JavaScript must be enabled.',
      ),
    ],
  );
}

Widget _uploadingFilesContent(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _DocsTitle('Uploading Files'),
      _DocSection(
        title: 'File requirements',
        content:
            'Maximum file size: 10 MB.\n'
            'Supported formats: any file type (PDF, PNG, JPG, MP4, ZIP, DOCX, etc.).\n'
            'Binary and text files are both stored as raw blobs — Perma.link does not inspect or transcode your content.',
      ),
      _DocSection(
        title: 'How to upload',
        content:
            'Drag and drop: drag your file directly onto the dashed drop zone on the upload screen. '
            'The zone highlights in cyan when a file is detected over it.\n\n'
            'Browse: click "Browse files" to open the system file picker. '
            'Only one file can be uploaded per session.',
      ),
      _DocSection(
        title: 'Two-phase upload progress',
        content:
            'Phase 1 — Walrus upload: your file bytes are sent to a Walrus publisher node on the testnet. '
            'The node stores the content across the network and returns a blob ID '
            '(a 32-byte content hash, e.g. blobId: "0xabc123...").\n\n'
            'Phase 2 — Link creation: Perma.link generates a random 6-character short code, '
            'writes the mapping (short code → blob ID) to Supabase, and returns your final URL. '
            'If the code collides with an existing one, it retries up to 3 times automatically.',
      ),
      _DocSection(
        title: 'Error handling',
        content:
            'Network errors on Phase 1 trigger an automatic retry with exponential back-off '
            '(up to 3 attempts). If all retries fail, a red error card appears with the reason.\n\n'
            'Common errors:\n'
            '• "File too large" — reduce file size below 10 MB.\n'
            '• "Walrus upload failed" — the testnet node may be temporarily unavailable; try again in a few minutes.\n'
            '• "Failed to save link" — a transient Supabase write error; refresh and retry.',
      ),
      _DocSection(
        title: 'Storage duration',
        content:
            'Files are stored for 3 Walrus epochs. On the current testnet, each epoch lasts '
            'approximately 1 day, giving a minimum storage window of around 3 days. '
            'Epoch durations are expected to increase significantly on mainnet.',
      ),
    ],
  );
}

Widget _sharingLinksContent(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _DocsTitle('Sharing Links'),
      _DocSection(
        title: 'Link anatomy',
        content:
            'Every link follows the pattern:\n\n'
            '  https://<domain>/<short-code>\n\n'
            'The short code is 6 lowercase alphanumeric characters generated randomly at upload time '
            '(e.g. a9k2xQ). The domain matches wherever the app is deployed.',
      ),
      _DocSection(
        title: 'Copy to clipboard',
        content:
            'After a successful upload, your link appears in the success card. '
            'Click the copy icon to write it to your clipboard instantly. '
            'A confirmation toast confirms the copy succeeded.',
      ),
      _DocSection(
        title: 'Native share',
        content:
            'On devices and browsers that support the Web Share API (most modern mobile browsers), '
            'a "Share" button appears alongside the copy button. '
            'Tapping it opens your OS-native share sheet so you can send the link to any app directly.',
      ),
      _DocSection(
        title: 'What visitors see',
        content:
            'When someone opens your link, the redirect screen resolves the short code to a blob ID '
            'in under 200 ms on average, then sends an HTTP redirect to the Walrus aggregator URL. '
            'The visitor\'s browser fetches the file directly from the Walrus network — '
            'no bandwidth passes through Perma.link\'s servers.',
      ),
      _DocSection(
        title: 'Accessing your stats page',
        content:
            'Every link has a companion stats page at:\n\n'
            '  https://<domain>/s/<short-code>\n\n'
            'Bookmark this URL after upload. It shows your total click count, upload date, '
            'file name, and file size. No account needed to view it.',
      ),
    ],
  );
}

Widget _analyticsContent(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _DocsTitle('Analytics'),
      _DocSection(
        title: 'What is tracked',
        content:
            'Perma.link records one data point per link: a total click count. '
            'Every time someone opens your short URL, the redirect handler calls a Postgres function '
            '(increment_click_count) that atomically increments the counter. '
            'This is fire-and-forget — it never blocks the redirect.',
      ),
      _DocSection(
        title: 'What is NOT tracked',
        content:
            'We do not log IP addresses, user agents, referrer URLs, geographic locations, '
            'or any personally identifiable information. There are no cookies or fingerprinting scripts. '
            'The click counter is the only analytics data we collect.',
      ),
      _DocSection(
        title: 'Stats page',
        content:
            'Navigate to /s/<short-code> to view your link\'s stats. The page shows:\n\n'
            '• Short code and full short URL\n'
            '• Original file name and file size\n'
            '• Date and time the link was created\n'
            '• Total click count (updates on every page refresh)\n\n'
            'The stats page is publicly accessible — anyone with the URL can view it.',
      ),
      _DocSection(
        title: 'Finding your stats page',
        content:
            'The stats URL is shown on the success card immediately after upload. '
            'If you did not note it, construct it manually:\n\n'
            '  Replace the domain in your short link with /s/ before the code:\n'
            '  perma.link/abc123  →  perma.link/s/abc123',
      ),
    ],
  );
}

Widget _apiReferenceContent(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _DocsTitle('API Reference'),
      _DocSection(
        title: 'Overview',
        content:
            'Perma.link is backed by a Supabase Postgres database. '
            'You can interact with it directly using the Supabase REST API or the supabase-js / supabase-dart SDK. '
            'All endpoints are public (no auth header required) because Row Level Security policies '
            'are configured to allow anonymous reads and inserts on the links table.',
      ),
      _DocSection(
        title: 'Base URL',
        content: 'https://<your-supabase-project>.supabase.co/rest/v1\n\n'
            'Required headers for all requests:\n'
            '  apikey: <SUPABASE_ANON_KEY>\n'
            '  Content-Type: application/json',
      ),
      _CodeBlock(
        title: 'Create a link (INSERT)',
        code: 'POST /links\n'
            'apikey: <SUPABASE_ANON_KEY>\n'
            'Content-Type: application/json\n'
            'Prefer: return=representation\n\n'
            '{\n'
            '  "short_code": "abc123",\n'
            '  "blob_id": "0xabc123...walrus-blob-id",\n'
            '  "file_name": "document.pdf",\n'
            '  "file_size": 102400\n'
            '}\n\n'
            '// 201 Created\n'
            '[\n'
            '  {\n'
            '    "id": "uuid",\n'
            '    "short_code": "abc123",\n'
            '    "blob_id": "0xabc123...",\n'
            '    "file_name": "document.pdf",\n'
            '    "file_size": 102400,\n'
            '    "click_count": 0,\n'
            '    "created_at": "2026-06-24T12:00:00Z"\n'
            '  }\n'
            ']',
      ),
      _CodeBlock(
        title: 'Resolve a short code (SELECT)',
        code: 'GET /links?short_code=eq.abc123&select=blob_id,file_name\n'
            'apikey: <SUPABASE_ANON_KEY>\n\n'
            '// 200 OK\n'
            '[\n'
            '  {\n'
            '    "blob_id": "0xabc123...",\n'
            '    "file_name": "document.pdf"\n'
            '  }\n'
            ']',
      ),
      _CodeBlock(
        title: 'Get link stats (SELECT)',
        code: 'GET /links?short_code=eq.abc123\n'
            'apikey: <SUPABASE_ANON_KEY>\n\n'
            '// 200 OK\n'
            '[\n'
            '  {\n'
            '    "short_code": "abc123",\n'
            '    "blob_id": "0xabc123...",\n'
            '    "file_name": "document.pdf",\n'
            '    "file_size": 102400,\n'
            '    "click_count": 42,\n'
            '    "created_at": "2026-06-24T12:00:00Z"\n'
            '  }\n'
            ']',
      ),
      _CodeBlock(
        title: 'Increment click count (RPC)',
        code: 'POST /rpc/increment_click_count\n'
            'apikey: <SUPABASE_ANON_KEY>\n'
            'Content-Type: application/json\n\n'
            '{ "code": "abc123" }\n\n'
            '// 200 OK (no body)\n'
            '// This calls the Postgres function increment_click_count(code text)\n'
            '// which atomically does: UPDATE links SET click_count = click_count + 1\n'
            '//                        WHERE short_code = code',
      ),
      _DocSection(
        title: 'Error codes',
        content:
            '400 Bad Request — malformed JSON or missing required field.\n'
            '409 Conflict — short_code already exists (Postgres unique violation 23505). '
            'The app retries with a new code automatically.\n'
            '404 Not Found — the requested short code does not exist in the database.',
      ),
    ],
  );
}

Widget _faqContent(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _DocsTitle('Frequently Asked Questions'),
      _FaqItem(
        question: 'Do I need an account to use Perma.link?',
        answer:
            'No. Perma.link is fully anonymous. You can upload files, create links, and '
            'view stats without ever creating an account or providing an email address.',
      ),
      _FaqItem(
        question: 'How long does my file stay available?',
        answer:
            'Files are stored on Walrus for 3 epochs. On the current testnet, an epoch is roughly 1 day, '
            'giving a minimum of ~3 days. On mainnet, epochs are expected to last much longer. '
            'The short link in Supabase persists indefinitely — if the blob expires, '
            'the redirect will fail with a 404 from the Walrus aggregator.',
      ),
      _FaqItem(
        question: 'What file types are supported?',
        answer:
            'Any file type up to 10 MB. Walrus stores raw bytes without inspecting content, '
            'so PDFs, images, videos, archives, code files, and binaries all work the same way.',
      ),
      _FaqItem(
        question: 'Can I update or delete a link?',
        answer:
            'Not yet. Links are immutable — once a short code is mapped to a blob ID, '
            'that mapping cannot be changed. Link expiry and deletion are planned for a future release.',
      ),
      _FaqItem(
        question: 'What is a blob ID?',
        answer:
            'A blob ID is a 32-byte content hash assigned by Walrus when your file is stored. '
            'It uniquely identifies your file on the network and is used to construct the '
            'direct aggregator URL (e.g. aggregator-url/v1/blobs/<blobId>). '
            'Perma.link hides this long identifier behind a 6-character short code.',
      ),
      _FaqItem(
        question: 'Why does the upload happen in two phases?',
        answer:
            'Phase 1 sends your file to a Walrus publisher node, which distributes erasure-coded '
            'shards across the network and returns a blob ID. '
            'Phase 2 saves the short code → blob ID mapping in Supabase so future redirects '
            'can look it up instantly. Both phases must succeed for your link to be created.',
      ),
      _FaqItem(
        question: 'Is there a rate limit?',
        answer:
            'There is no enforced rate limit in the current build. However, the Walrus testnet '
            'itself may throttle heavy usage. Please be considerate — this is a shared testnet resource.',
      ),
      _FaqItem(
        question: 'Can I customize my short code?',
        answer:
            'Not currently. Short codes are randomly generated 6-character alphanumeric strings. '
            'Custom vanity codes are on the roadmap for a future release.',
      ),
      _FaqItem(
        question: 'What happens if Walrus is unavailable?',
        answer:
            'The upload will fail at Phase 1 with a "Walrus upload failed" error. '
            'The app retries up to 3 times with exponential back-off before showing the error card. '
            'No link is created and no Supabase record is written. Try again once the network recovers.',
      ),
      _FaqItem(
        question: 'Is my file publicly accessible?',
        answer:
            'Yes. Anyone who knows your short link (or the underlying Walrus blob ID) can access the file. '
            'Do not upload sensitive or private content unless you are comfortable with public access. '
            'Password-protected links are planned for a future release.',
      ),
    ],
  );
}

class _DocsTitle extends StatelessWidget {
  const _DocsTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceLg),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}

class _DocSection extends StatelessWidget {
  const _DocSection({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spaceXs),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.muted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            decoration: AppTheme.glassCard(borderRadius: AppTheme.radiusMd),
            child: SelectableText(
              code,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'Courier New',
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spaceMd + 4),
            decoration: AppTheme.glassCard(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppTheme.primary,
                    ),
                  ],
                ),
                if (_expanded) ...[
                  const SizedBox(height: AppTheme.spaceMd),
                  Text(
                    widget.answer,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.muted,
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
