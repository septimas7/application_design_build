# {{PROJECT_NAME}} — Design Documentation

Version-controlled home for the **{{PROJECT_NAME}}** design: functional specifications, technical architecture, data dictionaries, interface directories (MCP Tools / API / Web Hooks / Events / User Exits), UI design, and the build task logs.

{{ONE_LINE_DESCRIPTION}} See [`Conventions/Documentation System Guide.md`](Conventions/Documentation%20System%20Guide.md) for how this documentation set is organized, created, and maintained.

## Repository structure

```
{{PROJECT_NAME}}/
├── README.md                 ← this file (navigation index)
├── tasks.md                  ← program + platform build log
├── Conventions/              ← how to create & maintain each document type
├── Platform/                 ← the Platform unit (cross-cutting foundation, "plugin zero")
│   ├── Functional Design.md
│   ├── Technical Design.md
│   ├── Directories/          ← canonical dictionaries + interfaces
│   └── UI/<page>/            ← UI Design Requirements + Mockups, one folder per page
└── Applications/             ← per-application docs (one folder each; same shape as Platform)
    └── <app>/
        ├── Functional Spec.md
        ├── Technical Design.md
        ├── Directories/
        ├── UI/<page>/
        └── tasks.md
```

Each **unit** (Platform and every Application) owns the same document shape: a Functional spec, a Technical Design, a `Directories/` set (the canonical source of truth for that unit's data, permissions, config, logs, and interfaces), a `UI/` folder with one subfolder per page, and its own `tasks.md`.

## Conventions

Every document type has a guide in [`Conventions/`](Conventions/) describing its structure, authoring rules, and maintenance discipline. Read the relevant guide before creating or editing a document. Authoring order for a unit: Functional → Technical → **UI → Directories** → (UI mockups) — designing the UI surfaces the entities the Directories formalize.

## Status

Bootstrapping — conventions are in place; author the Platform design first, then the first Application.