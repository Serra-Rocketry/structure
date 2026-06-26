# AGENTS.md

## O que é este repositório

Design e análise estrutural de foguetes da Serra Rocketry (IPRJ/UERJ). Cada pasta de missão contém modelos CAD, documentação de design, cálculos estruturais e hardware.

## Idioma

Todo o conteúdo é escrito em **Português (pt-BR)**. Commits e PRs seguem [Conventional Commits](https://www.conventionalcommits.org/pt-br/): `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.

## Estrutura

```
structure/
├── dedalo/          # Missão Dédalo (LASC 2026, 1 km SRM)
├── thonyan/         # Missão Thonyan (LASC 2026, 0.5 km SRM)
├── helike/          # Missão Helike (LASC 2026, CanSat)
└── README.md        # Visão geral e índice de missões
```

Cada missão segue a mesma estrutura interna:
```
missao/
├── docs/
│   ├── images/      # Renders e fotos
│   ├── DESIGN.md    # Decisões de design
│   └── CALCULOS.md  # Cálculos e FEA
├── hardware/
│   ├── cad/         # Modelos CAD (.FCStd, .step)
│   ├── 3d_models/   # STLs para impressão
│   └── README.md    # BOM, materiais, especificações
└── README.md        # Visão geral da missão
```

## Formatos CAD

- **FreeCAD (.FCStd)** — formato nativo preferido
- **STEP (.step)** — formato de intercâmbio (exportar sempre junto com .FCStd)
- **STL (.stl)** — para impressão 3D

SolidWorks pode ser usado localmente, mas deve exportar para STEP antes de commitar.

## Diretrizes para edição

- **Nomes de arquivo**: snake_case, lowercase, sem espaços
- **Imagens**: Comprimir antes de commitar (máx 500KB). Nomes descritivos: `nose_cone_ogive_v1_top.png`
- **Markdown**: Preservar estilo com emojis nos títulos e back-links `[← Voltar ao índice]`
- **Commits**: Uma mudança lógica por commit. Mensagens em português.
- **Sem software de análise**: Scripts Python ou simulações ficam no domínio de Telemetria, não aqui.

## Membros da Equipe

| Domínio | Membro | GitHub | Notas |
|---------|--------|--------|-------|
| Aerodinâmica e Estruturas | Pedro | [@PedroSerraRocketry](https://github.com/PedroSerraRocketry) | |
