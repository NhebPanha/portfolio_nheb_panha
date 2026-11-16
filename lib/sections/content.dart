import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/common.dart';

// ─────────────────────────────── About ───────────────────────────────

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final story = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'About',
            title: 'Developer with an eye for detail and data',
          ),
          const SizedBox(height: 24),
          for (final para in aboutParagraphs) ...[
            Text(
              para,
              style: TextStyle(fontSize: 16, height: 1.65, color: p.muted),
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final t in coreStack) TagChip(t)],
          ),
        ],
      ),
    );

    final cards = ResponsiveGrid(
      columns: Bp.sm(context) ? 2 : 1,
      gap: 16,
      children: [
        for (final (i, s) in services.indexed)
          Reveal(
            delay: Duration(milliseconds: 80 * i),
            child: AppCard(
              hover: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: p.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(s.icon, size: 22, color: p.accent),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    s.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: p.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.body,
                    style: TextStyle(fontSize: 14, height: 1.6, color: p.muted),
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    return Section(
      alt: true,
      child: Bp.lg(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: story),
                const SizedBox(width: 48),
                Expanded(flex: 7, child: cards),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [story, const SizedBox(height: 40), cards],
            ),
    );
  }
}

// ───────────────────────────── Experience ─────────────────────────────

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Reveal(
            child: SectionHeading(
              eyebrow: 'Experience',
              title: "Where I've worked",
              lead: 'Roles across mobile, web and backend development, most recent first.',
            ),
          ),
          const SizedBox(height: 56),
          for (final (i, job) in jobs.indexed)
            Reveal(
              delay: Duration(milliseconds: 90 * i),
              child: _JobEntry(
                job: job,
                first: i == 0,
                last: i == jobs.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _JobEntry extends StatelessWidget {
  const _JobEntry({required this.job, required this.first, required this.last});
  final Job job;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final wide = Bp.md(context);
    final period = Text(job.period, style: mono(12, p.muted));

    final body = Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!wide) ...[period, const SizedBox(height: 8)],
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                job.role,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: p.text,
                ),
              ),
              TagChip(job.type),
            ],
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: job.company,
                  style: TextStyle(fontWeight: FontWeight.w500, color: p.text),
                ),
                TextSpan(text: '  ·  ${job.location}'),
              ],
            ),
            style: TextStyle(fontSize: 14, color: p.muted),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 768),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.summary,
                  style: TextStyle(fontSize: 15, height: 1.65, color: p.muted),
                ),
                const SizedBox(height: 16),
                for (final h in job.highlights)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 9, right: 12),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: p.muted,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            h,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: p.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final t in job.tech) TagChip(t)],
          ),
        ],
      ),
    );

    // Timeline rail: a vertical line with a dot; the newest role's dot uses the accent color.
    final rail = SizedBox(
      width: 32,
      child: Stack(
        children: [
          Positioned(
            left: 6,
            top: first ? 8 : 0,
            bottom: last ? null : 0,
            height: last ? 8 : null,
            child: Container(width: 1, color: p.border),
          ),
          Positioned(
            left: 0,
            top: 6,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: first ? p.accent : p.border,
                shape: BoxShape.circle,
                border: Border.all(color: p.bg, width: 2),
              ),
            ),
          ),
        ],
      ),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (wide)
            SizedBox(
              width: 144,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, right: 24),
                child: Align(alignment: Alignment.topRight, child: period),
              ),
            ),
          rail,
          Expanded(child: body),
        ],
      ),
    );
  }
}

// ────────────────────────────── Projects ──────────────────────────────

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _category = 'All';
  String _query = '';

  List<String> get _categories => [
    'All',
    ...{for (final p in projects) p.category},
  ];

  List<Project> get _filtered {
    final q = _query.trim().toLowerCase();
    return projects.where((p) {
      if (_category != 'All' && p.category != _category) return false;
      if (q.isEmpty) return true;
      return [
        p.title,
        p.category,
        p.description,
        ...p.tags,
      ].any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final search = SizedBox(
      width: Bp.md(context) ? 288 : double.infinity,
      child: TextField(
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: 'Search by name or technology',
          prefixIcon: Icon(Icons.search, size: 18, color: p.muted),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
    const heading = SectionHeading(
      eyebrow: 'Projects',
      title: 'Selected work',
      lead: "Mobile apps I've designed and built, including the customer, merchant and driver apps behind the RED ANT Express e-commerce platform.",
    );
    final items = _filtered;

    return Section(
      alt: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Reveal(
            child: Bp.md(context)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Expanded(child: heading),
                      const SizedBox(width: 32),
                      search,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [heading, const SizedBox(height: 24), search],
                  ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in _categories)
                _FilterPill(
                  label: c,
                  selected: c == _category,
                  onTap: () => setState(() => _category = c),
                ),
            ],
          ),
          const SizedBox(height: 32),
          if (items.isEmpty)
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 36, color: p.muted),
                  const SizedBox(height: 12),
                  Text(
                    'No projects found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: p.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try a different search or category.',
                    style: TextStyle(fontSize: 14, color: p.muted),
                  ),
                ],
              ),
            )
          else
            ResponsiveGrid(
              columns: Bp.md(context) ? 2 : 1,
              children: [
                for (final (i, project) in items.indexed)
                  Reveal(
                    key: ValueKey(project.title),
                    delay: Duration(milliseconds: 70 * (i % 4)),
                    child: _ProjectCard(project: project),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? p.text : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? p.text : p.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: selected ? p.bg : p.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    void open() => showProjectDialog(context, project);

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: open,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              border: Border(bottom: BorderSide(color: p.border)),
            ),
            child: Row(children: [_IconTile(icon: project.icon)]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow(project.category),
                  const SizedBox(height: 8),
                  Text(
                    project.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: p.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, height: 1.6, color: p.muted),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [for (final t in project.tags) TagChip(t)],
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),
                  ArrowLink(label: 'View details', onTap: open),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, this.size = 48});
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border),
      ),
      child: Icon(icon, size: size * 0.5, color: p.accent),
    );
  }
}

Future<void> showProjectDialog(BuildContext context, Project project) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (context) {
      final p = context.pal;
      return _AppDialog(
        maxWidth: 576,
        title: project.title,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconTile(icon: project.icon, size: 56),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Eyebrow(project.category),
                      const SizedBox(height: 4),
                      Text(
                        project.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: p.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              project.description,
              style: TextStyle(fontSize: 15, height: 1.65, color: p.muted),
            ),
            const SizedBox(height: 24),
            Text(
              'Built with',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: p.text,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final t in project.tags) TagChip(t, large: true)],
            ),
            if (project.demoUrl != null || project.sourceUrl != null) ...[
              const SizedBox(height: 24),
              Divider(color: p.border, height: 1),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (project.demoUrl != null)
                    AppButton(
                      label: 'Live demo',
                      leadingIcon: Icons.open_in_new,
                      onPressed: () => openUrl(project.demoUrl!),
                    ),
                  if (project.sourceUrl != null)
                    AppButton(
                      label: 'Source code',
                      leadingIcon: Icons.code,
                      kind: ButtonKind.secondary,
                      onPressed: () => openUrl(project.sourceUrl!),
                    ),
                ],
              ),
            ],
          ],
        ),
      );
    },
  );
}

/// Shared dialog shell: bordered card, close button, scrolls when tall. Esc closes it.
class _AppDialog extends StatelessWidget {
  const _AppDialog({
    required this.child,
    required this.maxWidth,
    required this.title,
  });
  final Widget child;
  final double maxWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Dialog(
      backgroundColor: p.bg,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: p.border),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                Bp.sm(context) ? 40 : 24,
                32,
                Bp.sm(context) ? 40 : 24,
                32,
              ),
              child: Semantics(label: title, child: child),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: IconSquare(
                icon: Icons.close,
                tooltip: 'Close',
                bordered: false,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────── Skills ───────────────────────────────

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final columns = Bp.lg(context) ? 3 : (Bp.sm(context) ? 2 : 1);

    Widget header(IconData icon, String title) => Row(
      children: [
        Icon(icon, size: 22, color: p.accent),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: p.text,
          ),
        ),
      ],
    );

    final cards = <Widget>[
      for (final (i, g) in skillGroups.indexed)
        Reveal(
          delay: Duration(milliseconds: 70 * i),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(g.icon, g.title),
                const SizedBox(height: 20),
                for (final (name, note) in g.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: p.accent.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: p.text,
                            ),
                          ),
                        ),
                        if (note != null)
                          Text(
                            note,
                            style: TextStyle(fontSize: 12, color: p.muted),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      Reveal(
        delay: const Duration(milliseconds: 350),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(Icons.verified_outlined, 'How I work'),
              const SizedBox(height: 20),
              for (final practice in practices)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(Icons.check, size: 16, color: p.success),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          practice,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: p.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    ];

    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Reveal(
            child: SectionHeading(
              eyebrow: 'Skills',
              title: 'Tools and technologies',
              lead: 'The stack I use day to day, grouped by where it fits in a product.',
            ),
          ),
          const SizedBox(height: 48),
          ResponsiveGrid(columns: columns, children: cards),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Writing ───────────────────────────────

class WritingSection extends StatelessWidget {
  const WritingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final columns = Bp.lg(context) ? 3 : (Bp.md(context) ? 2 : 1);

    return Section(
      alt: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Reveal(
            child: SectionHeading(
              eyebrow: 'Writing',
              title: 'Notes and articles',
              lead: 'Short write-ups on mobile architecture, frontend performance and backend systems.',
            ),
          ),
          const SizedBox(height: 48),
          ResponsiveGrid(
            columns: columns,
            children: [
              for (final (i, post) in posts.indexed)
                Reveal(
                  delay: Duration(milliseconds: 80 * i),
                  child: AppCard(
                    onTap: () => showPostDialog(context, post),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PostMeta(post: post),
                        const SizedBox(height: 12),
                        Text(
                          post.title,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                            color: p.text,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.summary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: p.muted,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Text(
                              post.readTime,
                              style: TextStyle(fontSize: 14, color: p.muted),
                            ),
                            const Spacer(),
                            ArrowLink(
                              label: 'Read',
                              onTap: () => showPostDialog(context, post),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> showPostDialog(BuildContext context, Post post) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (context) {
      final p = context.pal;
      return _AppDialog(
        maxWidth: 672,
        title: post.title,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostMeta(post: post, withReadTime: true),
            const SizedBox(height: 12),
            Text(
              post.title,
              style: TextStyle(
                fontSize: Bp.sm(context) ? 30 : 24,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: p.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'By $ownerName',
              style: TextStyle(fontSize: 14, color: p.muted),
            ),
            const SizedBox(height: 32),
            Divider(color: p.border, height: 1),
            const SizedBox(height: 32),
            for (final block in post.content.split('\n\n'))
              ..._postParagraph(block, p),
            const SizedBox(height: 16),
            Divider(color: p.border, height: 1),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final t in post.tags) TagChip(t)],
            ),
          ],
        ),
      );
    },
  );
}

/// A block may be "### Heading\nBody text"; split it into heading + paragraph.
List<Widget> _postParagraph(String block, Palette p) {
  final lines = block.split('\n');
  final widgets = <Widget>[];
  final buffer = <String>[];
  void flush() {
    if (buffer.isEmpty) return;
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          buffer.join(' '),
          style: TextStyle(fontSize: 15, height: 1.75, color: p.muted),
        ),
      ),
    );
    buffer.clear();
  }

  for (final line in lines) {
    if (line.startsWith('### ')) {
      flush();
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: Text(
            line.substring(4),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: p.text,
            ),
          ),
        ),
      );
    } else {
      buffer.add(line);
    }
  }
  flush();
  return widgets;
}

class _PostMeta extends StatelessWidget {
  const _PostMeta({required this.post, this.withReadTime = false});
  final Post post;
  final bool withReadTime;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final dot = Text('  ·  ', style: TextStyle(fontSize: 12, color: p.muted));
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Eyebrow(post.category),
        dot,
        Text(post.date, style: TextStyle(fontSize: 12, color: p.muted)),
        if (withReadTime) ...[
          dot,
          Text(post.readTime, style: TextStyle(fontSize: 12, color: p.muted)),
        ],
      ],
    );
  }
}
