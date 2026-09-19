@echo off
rem = """
title Organizador Inteligente de Arquivos - LEG3NDY Edition
mode 80,32 >nul 2>&1
chcp 65001 >nul

set "PY_CMD="
where python >nul 2>&1 && set "PY_CMD=python"
if not defined PY_CMD where py >nul 2>&1 && set "PY_CMD=py"
if not defined PY_CMD (
    echo.
    echo ==============================================================================
    echo  [ERRO] O Python nao foi encontrado instalado neste computador!
    echo ==============================================================================
    echo.
    echo  Requisito do Sistema: Python 3.7 ou superior - Recomendado 3.10+
    echo  Download oficial:     https://www.python.org/downloads/
    echo.
    echo  * IMPORTANTE: No instalador do Python, marque a opcao:
    echo    "[X] Add Python to PATH" para que o terminal reconheca o comando.
    echo.
    pause
    exit /b 1
)
%PY_CMD% -x "%~f0" %*
exit /b %errorlevel%
"""
"""
==============================================================================
                ORGANIZADOR INTELIGENTE DE ARQUIVOS
       Inspirado no estilo interativo do MAS (Microsoft Activation Scripts)
==============================================================================
"""

import os
import sys
import shutil
import json
import unicodedata
from datetime import datetime
from typing import Dict, List, Any, Optional

# Verificação de versão mínima do interpretador
if sys.version_info < (3, 7):
    print("\n==============================================================================")
    print(" [ERRO] Versão do Python incompatível!")
    print(" O Organizador requer Python 3.7 ou superior (Recomendado 3.10+).")
    print(f" Versão detectada neste computador: {sys.version.split()[0]}")
    print(" Baixe a versão mais recente em: https://www.python.org/downloads/")
    print("==============================================================================\n")
    try:
        import msvcrt
        msvcrt.getch()
    except Exception:
        pass
    sys.exit(1)

# Suporte a tecla única sem precisar de Enter no Windows
try:
    import msvcrt
    HAS_MSVCRT = True
except ImportError:
    HAS_MSVCRT = False

# Habilita suporte ANSI e UTF-8 no terminal Windows
if sys.platform == "win32":
    os.system("")
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# Paleta de Cores ANSI (Estilo MAS)
C_RESET   = "\033[0m"
C_BOLD    = "\033[1m"
C_CYAN    = "\033[96m"
C_WHITE   = "\033[97m"
C_GREEN   = "\033[92m"
C_YELLOW  = "\033[93m"
C_RED     = "\033[91m"
C_MAGENTA = "\033[95m"
C_GRAY    = "\033[90m"
C_BLUE    = "\033[94m"

# Mapeamento Universal de Categorias (LEG3NDY Edition)
CATEGORIAS = {
    "Imagens": {
        "pasta": "Imagens",
        "exts": {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg", ".ico", ".bmp", ".tiff", ".tif", ".heic", ".heif", ".raw", ".cr2", ".nef", ".arw"}
    },
    "Vídeos": {
        "pasta": "Vídeos",
        "exts": {".mp4", ".mkv", ".avi", ".mov", ".wmv", ".webm", ".flv", ".m4v", ".mpg", ".mpeg", ".3gp", ".m2ts"}
    },
    "Áudio": {
        "pasta": "Áudio",
        "exts": {".mp3", ".wav", ".ogg", ".flac", ".aac", ".m4a", ".wma", ".opus", ".aiff", ".alac", ".mid", ".midi"}
    },
    "Documentos": {
        "pasta": "Documentos",
        "exts": {".pdf", ".docx", ".doc", ".txt", ".md", ".rtf", ".odt", ".pages", ".tex"}
    },
    "Planilhas": {
        "pasta": "Planilhas",
        "exts": {".xlsx", ".xls", ".csv", ".tsv", ".ods", ".numbers", ".xlsm", ".xlsb"}
    },
    "Apresentações": {
        "pasta": "Apresentações",
        "exts": {".pptx", ".ppt", ".pps", ".ppsx", ".odp", ".potx"}
    },
    "Livros e E-books": {
        "pasta": "Livros_e_Ebooks",
        "exts": {".epub", ".mobi", ".azw", ".azw3", ".cbr", ".cbz", ".djvu", ".fb2", ".ibooks"}
    },
    "Design e 3D": {
        "pasta": "Design_e_3D",
        "exts": {".psd", ".ai", ".eps", ".xd", ".fig", ".sketch", ".blend", ".obj", ".fbx", ".stl", ".step", ".stp", ".dwg", ".dxf", ".dae", ".ply", ".max", ".c4d"}
    },
    "Fontes": {
        "pasta": "Fontes",
        "exts": {".ttf", ".otf", ".woff", ".woff2", ".eot", ".fon"}
    },
    "Presets e Projetos": {
        "pasta": "Presets_e_Projetos",
        "exts": {".cube", ".xmp", ".lrtemplate", ".aep", ".prproj", ".drp", ".flp", ".als", ".cpr", ".fst", ".sf2", ".ffx"}
    },
    "Instaladores": {
        "pasta": "Instaladores",
        "exts": {".exe", ".msi", ".dmg", ".pkg", ".deb", ".rpm", ".appimage"}
    },
    "Mobile e APKs": {
        "pasta": "Mobile_e_APKs",
        "exts": {".apk", ".xapk", ".apks", ".ipa", ".aab"}
    },
    "Imagens de Disco": {
        "pasta": "Imagens_Disco",
        "exts": {".iso", ".img", ".vhd", ".vhdx", ".vmdk", ".vdi", ".bin", ".cue", ".nrg", ".mdf"}
    },
    "Compactados": {
        "pasta": "Compactados",
        "exts": {".zip", ".rar", ".7z", ".tar", ".gz", ".bz2", ".xz", ".tgz", ".zst", ".lzma", ".cab"}
    },
    "Código e Dev": {
        "pasta": "Código e Dev",
        "exts": {".json", ".py", ".js", ".ts", ".jsx", ".tsx", ".html", ".htm", ".css", ".scss", ".sass", ".less", ".yaml", ".yml", ".xml", ".sh", ".bash", ".bat", ".cmd", ".ps1", ".c", ".cpp", ".h", ".hpp", ".cs", ".java", ".rs", ".go", ".php", ".rb", ".swift", ".kt", ".lua", ".vue", ".dart"}
    },
    "Backups e Bancos": {
        "pasta": "Backups_e_Bancos",
        "exts": {".bak", ".backup", ".dump", ".sql", ".db", ".sqlite", ".sqlite3", ".db3", ".mdb", ".accdb", ".gho"}
    },
    "Chaves e Certificados": {
        "pasta": "Chaves_e_Certificados",
        "exts": {".pem", ".key", ".cer", ".crt", ".pfx", ".p12", ".der", ".csr", ".pub"}
    },
    "Jogos e ROMs": {
        "pasta": "Jogos_e_ROMs",
        "exts": {".rom", ".nes", ".sfc", ".smc", ".gba", ".gbc", ".nds", ".n64", ".nsp", ".xci", ".chd", ".rvz", ".cso", ".pbp", ".gcm", ".cia", ".3ds", ".mcworld", ".mcpack", ".mctemplate", ".pak", ".vpk"}
    },
    "Legendas": {
        "pasta": "Legendas",
        "exts": {".srt", ".sub", ".vtt", ".ass", ".ssa", ".idx"}
    },
    "Torrents": {
        "pasta": "Torrents",
        "exts": {".torrent"}
    },
    "Atalhos Web": {
        "pasta": "Atalhos_Web",
        "exts": {".url", ".webloc", ".website"}
    },
    "Outros": {
        "pasta": "Outros",
        "exts": set()
    }
}

# Tenta carregar config.json se existir no diretório do script
def carregar_config_customizada():
    global CATEGORIAS
    caminho_cfg = os.path.join(os.path.dirname(os.path.abspath(__file__)), "config.json")
    if os.path.exists(caminho_cfg):
        try:
            with open(caminho_cfg, "r", encoding="utf-8") as f:
                dados = json.load(f)
                if "categorias" in dados and isinstance(dados["categorias"], dict):
                    novas_cats = {}
                    for nome, cfg in dados["categorias"].items():
                        novas_cats[nome] = {
                            "pasta": cfg.get("pasta", nome),
                            "exts": set(ext.lower() for ext in cfg.get("exts", []))
                        }
                    CATEGORIAS = novas_cats
        except Exception:
            pass

carregar_config_customizada()

EXT_IGNORADAS = {".crdownload", ".part", ".tmp", ".download", ".aria2"}
ARQS_IGNORADOS = {
    "desktop.ini", "thumbs.db", ".ds_store", ".localized", ".trash",
    ".organizador_historico.json", "organizador.py", "build_cmd.py",
    "organizador-leg3ndy.cmd"
}

MARCADORES_SOFTWARE = {
    ".inf", ".sys", ".dll", ".ocx", ".cat",
    "setup.exe", "install.exe", "package.json",
    "cargo.toml", "requirements.txt", ".git"
}

ARQUIVO_HISTORICO = ".organizador_historico.json"

def formatar_tamanho(bytes_qty: int) -> str:
    if bytes_qty < 1024:
        return f"{bytes_qty} B"
    elif bytes_qty < 1024 * 1024:
        return f"{bytes_qty / 1024:.1f} KB"
    elif bytes_qty < 1024 * 1024 * 1024:
        return f"{bytes_qty / (1024 * 1024):.1f} MB"
    else:
        return f"{bytes_qty / (1024 * 1024 * 1024):.2f} GB"

def obter_categoria(nome_arquivo: str) -> str:
    nome_lower = nome_arquivo.lower()
    _, ext = os.path.splitext(nome_lower)

    # 1. Auto-detecção dinâmica: NUNCA move a si mesmo, independente de como o usuário renomear o arquivo!
    try:
        if nome_lower == os.path.basename(sys.argv[0]).lower():
            return "IGNORAR"
    except Exception:
        pass
    try:
        if nome_lower == os.path.basename(__file__).lower():
            return "IGNORAR"
    except Exception:
        pass

    # Ignora o histórico e qualquer variação que contenha organizador/organizar
    if "organizador" in nome_lower or "organizar" in nome_lower or nome_lower.startswith(".organizador"):
        return "IGNORAR"

    # 2. Ignorar arquivos de sistema ou temporários de download
    if ext in EXT_IGNORADAS or nome_lower in ARQS_IGNORADOS:
        return "IGNORAR"

    # Ignora dotfiles de configuração sem extensão (ex: .gitignore, .bashrc, .env)
    if nome_lower.startswith(".") and not ext:
        return "IGNORAR"

    for nome_cat, config in CATEGORIAS.items():
        if ext in config["exts"]:
            return nome_cat

    return "Outros"

def resolver_nome_unico(caminho_destino: str) -> str:
    """Garante que nunca sobrescreva um arquivo existente."""
    if not os.path.exists(caminho_destino):
        return caminho_destino
    diretorio, nome_completo = os.path.split(caminho_destino)
    nome_base, extensao = os.path.splitext(nome_completo)
    contador = 1
    while True:
        novo = os.path.join(diretorio, f"{nome_base} ({contador}){extensao}")
        if not os.path.exists(novo):
            return novo
        contador += 1

def esperar_tecla(msg: str = "Pressione qualquer tecla para voltar ao menu..."):
    print(f"\n{C_GRAY}{msg}{C_RESET}", end="", flush=True)
    if HAS_MSVCRT and sys.stdin.isatty():
        msvcrt.getch()
        print()
    else:
        try:
            input()
        except EOFError:
            pass

def ler_tecla_opcao() -> str:
    """Lê tecla única se estiver no terminal interativo, ou usa input() padrão."""
    if HAS_MSVCRT and sys.stdin.isatty():
        try:
            ch = msvcrt.getch().decode("utf-8", errors="ignore").strip()
            print(ch)
            return ch
        except Exception:
            pass
    try:
        return input().strip()
    except EOFError:
        return "0"

def gravar_json_oculto(caminho_arquivo: str, dados: Any) -> bool:
    """Grava dados em JSON garantindo que no Windows arquivos com atributo oculto não causem PermissionError."""
    try:
        if sys.platform == "win32" and os.path.exists(caminho_arquivo):
            try:
                import ctypes
                ctypes.windll.kernel32.SetFileAttributesW(caminho_arquivo, 128) # FILE_ATTRIBUTE_NORMAL (0x80)
            except Exception:
                pass

        with open(caminho_arquivo, "w", encoding="utf-8") as f:
            json.dump(dados, f, indent=2, ensure_ascii=False)

        if sys.platform == "win32":
            try:
                import ctypes
                ctypes.windll.kernel32.SetFileAttributesW(caminho_arquivo, 2) # FILE_ATTRIBUTE_HIDDEN (0x2)
            except Exception:
                pass
        return True
    except Exception as e:
        print(f"{C_RED}Erro ao salvar histórico: {e}{C_RESET}")
        return False

def salvar_historico(pasta_base: str, tipo_acao: str, movimentacoes: List[Dict[str, str]]):
    if not movimentacoes:
        return
    caminho_hist = os.path.join(pasta_base, ARQUIVO_HISTORICO)
    historico = []
    if os.path.exists(caminho_hist):
        try:
            with open(caminho_hist, "r", encoding="utf-8") as f:
                historico = json.load(f)
        except Exception:
            historico = []

    historico.append({
        "data_hora": datetime.now().strftime("%d/%m/%Y %H:%M:%S"),
        "tipo": tipo_acao,
        "total": len(movimentacoes),
        "movimentacoes": movimentacoes
    })

    gravar_json_oculto(caminho_hist, historico)

def escanear_arquivos(pasta_base: str) -> Dict[str, Any]:
    resultado = {cat: [] for cat in CATEGORIAS.keys()}
    total_bytes = 0
    total_arqs = 0

    try:
        itens = os.listdir(pasta_base)
    except Exception as e:
        return {"erro": str(e), "total_arqs": 0, "total_fmt": "0 B"}

    for item in itens:
        caminho = os.path.join(pasta_base, item)
        if not os.path.isfile(caminho):
            continue
        cat = obter_categoria(item)
        if cat == "IGNORAR":
            continue

        try:
            tam = os.path.getsize(caminho)
        except OSError:
            tam = 0

        total_bytes += tam
        total_arqs += 1
        resultado[cat].append({
            "nome": item,
            "caminho": caminho,
            "tamanho": tam,
            "tamanho_fmt": formatar_tamanho(tam)
        })

    return {
        "categorias": resultado,
        "total_arqs": total_arqs,
        "total_bytes": total_bytes,
        "total_fmt": formatar_tamanho(total_bytes)
    }

IGNORAR_DIRS_PESADOS = {
    "node_modules", ".git", "venv", ".venv", "env",
    "__pycache__", ".next", ".nuxt", "dist", "build",
    "target", "vendor", ".idea", ".vscode"
}

def remover_acentos(texto: str) -> str:
    return "".join(
        c for c in unicodedata.normalize("NFD", texto)
        if unicodedata.category(c) != "Mn"
    )

def obter_mapeamento_pastas_organizador() -> Dict[str, str]:
    mapeamento = {}
    for cat_nome, c in CATEGORIAS.items():
        pasta = c["pasta"]
        pasta_lower = pasta.lower()
        pasta_sem_acento = remover_acentos(pasta_lower)

        formas = {
            pasta_lower,
            pasta_sem_acento,
            pasta_lower.replace("_", " "),
            pasta_sem_acento.replace("_", " "),
            pasta_lower.replace(" ", "_"),
            pasta_sem_acento.replace(" ", "_"),
            cat_nome.lower(),
            remover_acentos(cat_nome.lower()),
            cat_nome.lower().replace(" ", "_"),
            remover_acentos(cat_nome.lower()).replace(" ", "_")
        }
        for f in formas:
            if f and f not in mapeamento:
                mapeamento[f] = cat_nome

    return mapeamento

def contar_subpastas_rapido(pasta_base: str) -> int:
    """Conta rapidamente todas as subpastas em 0.0001s sem varredura profunda."""
    try:
        return sum(
            1 for item in os.scandir(pasta_base)
            if item.is_dir() and not item.name.startswith(".")
        )
    except Exception:
        return 0

def analisar_subpastas(pasta_base: str) -> List[Dict[str, Any]]:
    pastas_sistema = obter_mapeamento_pastas_organizador()
    resultado = []

    try:
        itens = [e for e in os.scandir(pasta_base) if e.is_dir() and not e.name.startswith(".")]
        itens.sort(key=lambda e: e.name.lower())
    except Exception:
        return []

    for item_dir in itens:
        caminho_pasta = item_dir.path
        nome = item_dir.name
        nome_lower = nome.lower()

        # 1. Se for uma pasta criada e gerenciada pelo próprio organizador
        if nome_lower in pastas_sistema:
            cat_nome = pastas_sistema[nome_lower]
            arqs_count = 0
            tam_total = 0
            try:
                for raiz, dirs, arqs in os.walk(caminho_pasta):
                    dirs[:] = [d for d in dirs if d.lower() not in IGNORAR_DIRS_PESADOS and not d.startswith(".")]
                    for a in arqs:
                        arqs_count += 1
                        try:
                            tam_total += os.path.getsize(os.path.join(raiz, a))
                        except OSError:
                            pass
            except Exception:
                pass

            resultado.append({
                "nome": nome,
                "caminho": caminho_pasta,
                "qtd": arqs_count,
                "tamanho_fmt": formatar_tamanho(tam_total),
                "tipo": "PASTA_ORGANIZADA",
                "cat_dominante": cat_nome,
                "motivo": f"Pasta oficial do organizador para '{cat_nome}'"
            })
            continue

        # 2. Detecção ultrarrápida no nível 1 da subpasta (identifica projetos em 0.001s)
        try:
            entradas_nivel1 = {e.name.lower() for e in os.scandir(caminho_pasta)}
            if any(m in entradas_nivel1 for m in ["package.json", ".git", "cargo.toml", "setup.py", "requirements.txt", "go.mod", "tsconfig.json", "node_modules"]):
                resultado.append({
                    "nome": nome,
                    "caminho": caminho_pasta,
                    "qtd": len(entradas_nivel1),
                    "tamanho_fmt": "Projeto",
                    "tipo": "SOFTWARE_DRIVER",
                    "cat_dominante": None,
                    "motivo": "Projeto de código / software detectado. Não desmembrar!"
                })
                continue
        except Exception:
            pass

        # 3. Varredura com poda inteligente de pastas pesadas (node_modules, etc)
        arquivos_internos = []
        tam_total = 0
        contagem_cats: Dict[str, int] = {}
        tem_marcador_software = False

        try:
            for raiz, dirs, arqs in os.walk(caminho_pasta):
                # Poda imediata: impede o os.walk de entrar em node_modules ou .git
                dirs[:] = [d for d in dirs if d.lower() not in IGNORAR_DIRS_PESADOS]

                for a in arqs:
                    caminho_a = os.path.join(raiz, a)
                    a_low = a.lower()
                    _, ext = os.path.splitext(a_low)
                    if ext in MARCADORES_SOFTWARE or a_low in MARCADORES_SOFTWARE:
                        tem_marcador_software = True
                    try:
                        tam = os.path.getsize(caminho_a)
                    except OSError:
                        tam = 0
                    tam_total += tam
                    cat = obter_categoria(a)
                    contagem_cats[cat] = contagem_cats.get(cat, 0) + 1
                    arquivos_internos.append(a)

                    if len(arquivos_internos) >= 500:
                        break
                if len(arquivos_internos) >= 500:
                    break
        except Exception:
            pass

        qtd = len(arquivos_internos)
        tipo = "MISTA"
        motivo = ""
        cat_dominante = None

        if qtd == 0:
            tipo = "VAZIA"
            motivo = "Pasta vazia (0 arquivos)"
        elif tem_marcador_software:
            tipo = "SOFTWARE_DRIVER"
            motivo = "Pacote de software/driver (.inf, .sys, .dll, setup). Não desmembrar!"
        else:
            for cat, cnt in contagem_cats.items():
                if cat != "IGNORAR" and qtd > 0 and (cnt / qtd) >= 0.75:
                    tipo = "COLECAO"
                    cat_dominante = cat
                    motivo = f"Coleção homogênea: {cnt}/{qtd} arquivos são {cat} ({int(cnt/qtd*100)}%)"
                    break
            if tipo == "MISTA":
                motivo = f"Arquivos variados ({qtd} itens)"

        resultado.append({
            "nome": nome,
            "caminho": caminho_pasta,
            "qtd": qtd,
            "tamanho_fmt": formatar_tamanho(tam_total),
            "tipo": tipo,
            "cat_dominante": cat_dominante,
            "motivo": motivo
        })

    return resultado

# ══════════════════════════════════════════════════════════════════════
# AÇÕES DO MENU
# ══════════════════════════════════════════════════════════════════════

def limpar_tela():
    os.system("cls" if os.name == "nt" else "clear")

def acao_simular(pasta_base: str):
    limpar_tela()
    print(f"{C_CYAN}==============================================================================")
    print(f"            SIMULAÇÃO DE ORGANIZAÇÃO (NENHUM ARQUIVO SERÁ MOVIDO)")
    print(f"=============================================================================={C_RESET}")
    
    dados = escanear_arquivos(pasta_base)
    if "erro" in dados:
        print(f"\n{C_RED}Erro ao ler pasta: {dados['erro']}{C_RESET}")
        esperar_tecla()
        return

    if dados["total_arqs"] == 0:
        print(f"\n{C_GREEN}Nenhum arquivo solto encontrado na raiz. A pasta já está organizada!{C_RESET}")
        esperar_tecla()
        return

    print(f"\n  Pasta:            {C_YELLOW}{pasta_base}{C_RESET}")
    print(f"  Total Encontrado: {C_BOLD}{dados['total_arqs']}{C_RESET} arquivos soltos ({dados['total_fmt']})\n")
    print(f"{C_GRAY}------------------------------------------------------------------------------{C_RESET}")

    for cat, arqs in dados["categorias"].items():
        if not arqs:
            continue
        pasta_dest = CATEGORIAS[cat]["pasta"]
        print(f"\n{C_YELLOW}📁 {pasta_dest}/{C_RESET} {C_GRAY}({len(arqs)} arquivos){C_RESET}")
        for a in arqs[:6]:
            print(f"   ↳ {C_WHITE}{a['nome']}{C_RESET} {C_GRAY}({a['tamanho_fmt']}){C_RESET}")
        if len(arqs) > 6:
            print(f"   {C_GRAY}... e mais {len(arqs) - 6} arquivos.{C_RESET}")

    print(f"\n{C_GRAY}------------------------------------------------------------------------------{C_RESET}")
    print(f"{C_GREEN}✔ Simulação concluída com sucesso. Zero alterações efetuadas.{C_RESET}")
    esperar_tecla()

def acao_organizar(pasta_base: str):
    limpar_tela()
    print(f"{C_CYAN}==============================================================================")
    print(f"                     EXECUTAR ORGANIZAÇÃO DE ARQUIVOS")
    print(f"=============================================================================={C_RESET}")

    dados = escanear_arquivos(pasta_base)
    if dados.get("total_arqs", 0) == 0:
        print(f"\n{C_GREEN}Nenhum arquivo solto encontrado para organizar!{C_RESET}")
        esperar_tecla()
        return

    print(f"\n  Pasta:  {C_YELLOW}{pasta_base}{C_RESET}")
    print(f"  Meta:   {C_BOLD}{dados['total_arqs']}{C_RESET} arquivos soltos ({dados['total_fmt']})\n")
    print(f"{C_GRAY}------------------------------------------------------------------------------{C_RESET}")
    print(f"{C_YELLOW}Deseja realmente mover os arquivos para pastas organizadas agora? [S/N]{C_RESET}")
    print(f"{C_GRAY}(Pressione 'S' para confirmar ou qualquer outra tecla para cancelar){C_RESET}")
    
    confirma = ler_tecla_opcao().lower()
    if confirma != "s":
        print(f"\n{C_GRAY}Operação cancelada pelo usuário.{C_RESET}")
        esperar_tecla()
        return

    movimentacoes = []
    print(f"\n{C_CYAN}Movendo arquivos com proteção anti-sobrescrita ativa...{C_RESET}\n")

    for cat, arqs in dados["categorias"].items():
        if not arqs:
            continue
        pasta_dest = os.path.join(pasta_base, CATEGORIAS[cat]["pasta"])
        os.makedirs(pasta_dest, exist_ok=True)

        for a in arqs:
            origem = a["caminho"]
            destino_desejado = os.path.join(pasta_dest, a["nome"])
            destino_final = resolver_nome_unico(destino_desejado)

            try:
                shutil.move(origem, destino_final)
                movimentacoes.append({"origem": origem, "destino": destino_final})
            except Exception as e:
                print(f"{C_RED}✖ Erro ao mover {a['nome']}: {e}{C_RESET}")

    salvar_historico(pasta_base, "ARQUIVOS_SOLTOS", movimentacoes)
    print(f"\n{C_GREEN}✔ SUCESSO! {len(movimentacoes)} arquivos organizados com segurança.{C_RESET}")
    print(f"{C_GRAY}(Dica: você pode reverter tudo a qualquer momento usando a opção [5] Desfazer){C_RESET}")
    esperar_tecla()

def acao_diagnosticar_pastas(pasta_base: str):
    limpar_tela()
    print(f"{C_CYAN}==============================================================================")
    print(f"                 DIAGNÓSTICO E ANÁLISE DE SUBPASTAS")
    print(f"=============================================================================={C_RESET}")

    pastas = analisar_subpastas(pasta_base)
    if not pastas:
        print(f"\n{C_GRAY}Nenhuma subpasta encontrada nesta pasta.{C_RESET}")
        esperar_tecla()
        return

    print(f"\nSubpastas identificadas: {C_BOLD}{len(pastas)}{C_RESET}\n")
    print(f"{C_GRAY}------------------------------------------------------------------------------{C_RESET}")

    for i, p in enumerate(pastas, 1):
        if p["tipo"] == "PASTA_ORGANIZADA":
            badge = f"{C_GREEN}[PASTA DO ORGANIZADOR]{C_RESET}"
            rec = f"{C_GREEN}Pasta oficial do script • Destino padrão para '{p['cat_dominante']}'{C_RESET}"
        elif p["tipo"] == "SOFTWARE_DRIVER":
            badge = f"{C_MAGENTA}[DRIVER / SOFTWARE]{C_RESET}"
            rec = f"{C_MAGENTA}Recomendado: Manter Intacto (Protegido contra quebra){C_RESET}"
        elif p["tipo"] == "COLECAO":
            badge = f"{C_BLUE}[COLEÇÃO TEMÁTICA]{C_RESET}"
            rec = f"{C_CYAN}Recomendado: Mover pasta inteira para {p['cat_dominante']}/{p['nome']}{C_RESET}"
        elif p["tipo"] == "VAZIA":
            badge = f"{C_GRAY}[PASTA VAZIA]{C_RESET}"
            rec = f"{C_YELLOW}Recomendado: Limpeza segura (opção 4){C_RESET}"
        else:
            badge = f"{C_YELLOW}[MISTA]{C_RESET}"
            rec = f"{C_GRAY}Requer decisão manual{C_RESET}"

        print(f"{C_YELLOW}[{i:2d}]{C_RESET} {C_BOLD}{p['nome']}{C_RESET} {badge}")
        print(f"     ↳ {p['qtd']} arquivos ({p['tamanho_fmt']}) • {p['motivo']}")
        print(f"     ↳ {rec}\n")

    print(f"{C_GRAY}------------------------------------------------------------------------------{C_RESET}")
    esperar_tecla()

def tratar_erro_remocao(func, path, exc_info):
    import stat
    try:
        os.chmod(path, stat.S_IWRITE)
        func(path)
    except Exception:
        pass

def acao_reorganizar_subpastas(pasta_base: str):
    limpar_tela()
    print(f"{C_CYAN}==============================================================================")
    print(f"                     GERENCIAR SUBPASTAS SELECIONADAS")
    print(f"=============================================================================={C_RESET}")

    pastas = analisar_subpastas(pasta_base)
    if not pastas:
        print(f"\n{C_GRAY}Nenhuma subpasta disponível.{C_RESET}")
        esperar_tecla()
        return

    for i, p in enumerate(pastas, 1):
        if p["tipo"] == "PASTA_ORGANIZADA":
            badge = f"{C_GREEN}[PASTA DO ORGANIZADOR]{C_RESET}"
        elif p["tipo"] == "SOFTWARE_DRIVER":
            badge = f"{C_MAGENTA}[DRIVER / SOFTWARE]{C_RESET}"
        elif p["tipo"] == "COLECAO":
            badge = f"{C_BLUE}[COLEÇÃO TEMÁTICA]{C_RESET}"
        elif p["tipo"] == "VAZIA":
            badge = f"{C_GRAY}[PASTA VAZIA]{C_RESET}"
        else:
            badge = f"{C_YELLOW}[MISTA]{C_RESET}"
        print(f" {C_YELLOW}[{i:2d}]{C_RESET} {p['nome']} {C_GRAY}({p['qtd']} arqs, {p['tamanho_fmt']}) {badge}")

    print(f"\n{C_GRAY}------------------------------------------------------------------------------{C_RESET}")
    escolha = input(f"{C_BOLD}Digite o NÚMERO da pasta que deseja gerenciar (ou 0 para voltar): {C_RESET}").strip()
    if not escolha.isdigit() or int(escolha) < 1 or int(escolha) > len(pastas):
        return

    p = pastas[int(escolha) - 1]
    print(f"\nGerenciando: {C_BOLD}{C_WHITE}{p['nome']}{C_RESET} {C_GRAY}({p['motivo']}){C_RESET}\n")

    if p["tipo"] == "PASTA_ORGANIZADA":
        print(f"{C_GREEN}✔ Esta pasta é uma das categorias padrão criadas pelo organizador.{C_RESET}")
        print(f"  Categoria vinculada: {C_BOLD}{p['cat_dominante']}{C_RESET}")
        print(f"  Contém atualmente:   {C_BOLD}{p['qtd']}{C_RESET} arquivos ({p['tamanho_fmt']})")
        if p["qtd"] == 0:
            print(f"\n{C_GRAY}Esta pasta está atualmente vazia.{C_RESET}")
            conf = input(f"Deseja remover esta pasta de categoria vazia? [S/N]: ").strip().lower()
            if conf == "s":
                try:
                    shutil.rmtree(p["caminho"], onerror=tratar_erro_remocao)
                    print(f"{C_GREEN}✔ Pasta vazia removida com sucesso!{C_RESET}")
                except Exception as e:
                    print(f"{C_RED}Erro ao remover: {e}{C_RESET}")
                esperar_tecla()
                return
        else:
            print(f"\n{C_YELLOW}Dica:{C_RESET} Esta pasta serve como destino automático para novas organizações.")
            print(f"      Recomendamos mantê-la intacta.")
            esperar_tecla()
            return

    if p["tipo"] == "VAZIA":
        conf = input(f"Deseja excluir a pasta vazia '{p['nome']}'? [S/N]: ").strip().lower()
        if conf == "s":
            try:
                shutil.rmtree(p["caminho"], onerror=tratar_erro_remocao)
                print(f"{C_GREEN}✔ Pasta vazia excluída com sucesso!{C_RESET}")
            except Exception as e:
                print(f"{C_RED}Erro ao excluir: {e}{C_RESET}")
        esperar_tecla()
        return

    if p["tipo"] == "SOFTWARE_DRIVER":
        print(f"{C_MAGENTA}⚠ AVISO: Esta pasta contém drivers ou programas interdependentes.{C_RESET}")
        print(f"  {C_YELLOW}[1]{C_RESET} Mover pasta inteira para 'Instaladores/{p['nome']}'")
        print(f"  {C_YELLOW}[0]{C_RESET} Cancelar e manter intacta onde está")
        sub_opt = ler_tecla_opcao()
        if sub_opt == "1":
            dest_dir = os.path.join(pasta_base, "Instaladores")
            os.makedirs(dest_dir, exist_ok=True)
            dest_final = resolver_nome_unico(os.path.join(dest_dir, p["nome"]))
            try:
                shutil.move(p["caminho"], dest_final)
                salvar_historico(pasta_base, f"MOVER_PASTA_{p['nome']}", [{"origem": p["caminho"], "destino": dest_final}])
                print(f"\n{C_GREEN}✔ Pasta movida com segurança para Instaladores/{p['nome']}{C_RESET}")
            except Exception as e:
                print(f"{C_RED}Erro: {e}{C_RESET}")
            esperar_tecla()
        return

    if p["tipo"] == "COLECAO" or p["tipo"] == "MISTA":
        cat_sugerida = p["cat_dominante"] or "Outros"
        pasta_cat = CATEGORIAS.get(cat_sugerida, {}).get("pasta", cat_sugerida)

        print(f"  {C_YELLOW}[1]{C_RESET} Mover pasta inteira para '{pasta_cat}/{p['nome']}' (Recomendado)")
        print(f"  {C_YELLOW}[2]{C_RESET} Desmembrar arquivos internos para as pastas gerais")
        print(f"  {C_YELLOW}[0]{C_RESET} Cancelar")
        sub_opt = ler_tecla_opcao()

        if sub_opt == "1":
            dest_dir = os.path.join(pasta_base, pasta_cat)
            os.makedirs(dest_dir, exist_ok=True)
            dest_final = resolver_nome_unico(os.path.join(dest_dir, p["nome"]))
            try:
                shutil.move(p["caminho"], dest_final)
                salvar_historico(pasta_base, f"MOVER_PASTA_{p['nome']}", [{"origem": p["caminho"], "destino": dest_final}])
                print(f"\n{C_GREEN}✔ Pasta movida para {pasta_cat}/{p['nome']}{C_RESET}")
            except Exception as e:
                print(f"{C_RED}Erro: {e}{C_RESET}")
            esperar_tecla()

        elif sub_opt == "2":
            conf = input(f"\n{C_RED}Tem certeza que deseja espalhar os arquivos desta pasta? [S/N]: {C_RESET}").strip().lower()
            if conf == "s":
                movs = []
                for raiz, _, arqs in os.walk(p["caminho"], topdown=False):
                    for a in arqs:
                        cat = obter_categoria(a)
                        p_dest = CATEGORIAS.get(cat, {}).get("pasta", "Outros")
                        dest_dir = os.path.join(pasta_base, p_dest)
                        os.makedirs(dest_dir, exist_ok=True)
                        orig = os.path.join(raiz, a)
                        dest_f = resolver_nome_unico(os.path.join(dest_dir, a))
                        try:
                            shutil.move(orig, dest_f)
                            movs.append({"origem": orig, "destino": dest_f})
                        except Exception:
                            pass
                try:
                    shutil.rmtree(p["caminho"])
                except Exception:
                    pass
                salvar_historico(pasta_base, f"DESMEMBRAR_{p['nome']}", movs)
                print(f"\n{C_GREEN}✔ {len(movs)} arquivos organizados com sucesso.{C_RESET}")
            esperar_tecla()

def acao_desfazer(pasta_base: str):
    limpar_tela()
    print(f"{C_CYAN}==============================================================================")
    print(f"                       DESFAZER ÚLTIMA OPERAÇÃO (UNDO)")
    print(f"=============================================================================={C_RESET}")

    caminho_hist = os.path.join(pasta_base, ARQUIVO_HISTORICO)
    if not os.path.exists(caminho_hist):
        print(f"\n{C_GRAY}Nenhum histórico encontrado para desfazer nesta pasta.{C_RESET}")
        esperar_tecla()
        return

    try:
        with open(caminho_hist, "r", encoding="utf-8") as f:
            historico = json.load(f)
    except Exception:
        historico = []

    if not historico:
        print(f"\n{C_GRAY}Histórico de operações está vazio.{C_RESET}")
        esperar_tecla()
        return

    ultima = historico.pop()
    print(f"\n  Operação:     {C_YELLOW}{ultima['tipo']}{C_RESET}")
    print(f"  Data e Hora:  {C_GRAY}{ultima['data_hora']}{C_RESET}")
    print(f"  Itens:        {C_BOLD}{ultima['total']}{C_RESET} arquivos/pastas movidos")
    print(f"\n{C_GRAY}------------------------------------------------------------------------------{C_RESET}")
    print(f"{C_YELLOW}Deseja restaurar todos estes arquivos de volta ao local de origem? [S/N]{C_RESET}")

    confirma = ler_tecla_opcao().lower()
    if confirma != "s":
        print(f"\n{C_GRAY}Restauração cancelada.{C_RESET}")
        esperar_tecla()
        return

    restaurados = 0
    print(f"\n{C_CYAN}Restaurando arquivos...{C_RESET}")

    for m in reversed(ultima["movimentacoes"]):
        origem = m["origem"]
        destino = m["destino"]
        if os.path.exists(destino):
            try:
                os.makedirs(os.path.dirname(origem), exist_ok=True)
                volta = resolver_nome_unico(origem)
                shutil.move(destino, volta)
                restaurados += 1
            except Exception as e:
                print(f"{C_RED}✖ Falha ao restaurar {os.path.basename(destino)}: {e}{C_RESET}")

    gravar_json_oculto(caminho_hist, historico)

    print(f"\n{C_GREEN}✔ Concluído! {restaurados} itens restaurados para o local original.{C_RESET}")
    esperar_tecla()

# ══════════════════════════════════════════════════════════════════════
# LOOP PRINCIPAL (INTERFACE ESTILO MAS)
# ══════════════════════════════════════════════════════════════════════

def main():
    if len(sys.argv) > 1 and sys.argv[1].strip() and os.path.isdir(sys.argv[1].strip().rstrip('"\\')):
        pasta_padrao = os.path.abspath(sys.argv[1].strip().rstrip('"\\'))
    else:
        # Por padrão, assume a pasta onde o próprio script/launcher está localizado!
        dir_onde_esta = os.path.dirname(os.path.abspath(sys.argv[0]))
        if dir_onde_esta and os.path.isdir(dir_onde_esta):
            pasta_padrao = dir_onde_esta
        else:
            pasta_padrao = os.getcwd()

    pasta_atual = os.path.abspath(pasta_padrao)

    while True:
        limpar_tela()
        dados_raiz = escanear_arquivos(pasta_atual)
        total_subpastas = contar_subpastas_rapido(pasta_atual)

        total_arqs = dados_raiz.get("total_arqs", 0)
        total_fmt = dados_raiz.get("total_fmt", "0 B")

        print(f"{C_CYAN}==============================================================================")
        print(f"{C_BOLD}{C_WHITE}                  ORGANIZADOR INTELIGENTE DE ARQUIVOS")
        print(f"{C_CYAN}{C_BOLD}                            LEG3NDY Edition{C_RESET}")
        print(f"{C_CYAN}=============================================================================={C_RESET}")
        print(f"  {C_BOLD}Pasta Ativa:{C_RESET}      {C_YELLOW}{pasta_atual}{C_RESET}")
        print(f"  {C_BOLD}Arquivos Soltos:{C_RESET}  {C_GREEN}{total_arqs}{C_RESET} arquivos soltos ({total_fmt})")
        print(f"  {C_BOLD}Subpastas:{C_RESET}        {C_BLUE}{total_subpastas}{C_RESET} diretórios existentes")
        print(f"{C_GRAY}------------------------------------------------------------------------------{C_RESET}")
        print(f"  {C_YELLOW}[1]{C_RESET}  Simular Organização dos Arquivos Soltos {C_GRAY}(Ver lista sem mover){C_RESET}")
        print(f"  {C_YELLOW}[2]{C_RESET}  Organizar Arquivos Soltos Agora {C_GREEN}(Executar movimentação){C_RESET}")
        print(f"{C_GRAY}------------------------------------------------------------------------------{C_RESET}")
        print(f"  {C_YELLOW}[3]{C_RESET}  Diagnóstico Inteligente de Subpastas {C_GRAY}(Heurística de Software/Fotos){C_RESET}")
        print(f"  {C_YELLOW}[4]{C_RESET}  Gerenciar Subpastas Selecionadas {C_GRAY}(Mover pasta inteira / Limpar){C_RESET}")
        print(f"{C_GRAY}------------------------------------------------------------------------------{C_RESET}")
        print(f"  {C_YELLOW}[5]{C_RESET}  Desfazer Última Organização {C_MAGENTA}(Undo / Rollback){C_RESET}")
        print(f"  {C_YELLOW}[6]{C_RESET}  Alterar Pasta de Trabalho")
        print(f"{C_GRAY}------------------------------------------------------------------------------{C_RESET}")
        print(f"  {C_YELLOW}[0]{C_RESET}  Sair")
        print(f"{C_CYAN}=============================================================================={C_RESET}")
        print(f"  {C_BOLD}Escolha uma opção: {C_RESET}", end="", flush=True)

        opcao = ler_tecla_opcao()

        if opcao == "1":
            acao_simular(pasta_atual)
        elif opcao == "2":
            acao_organizar(pasta_atual)
        elif opcao == "3":
            acao_diagnosticar_pastas(pasta_atual)
        elif opcao == "4":
            acao_reorganizar_subpastas(pasta_atual)
        elif opcao == "5":
            acao_desfazer(pasta_atual)
        elif opcao == "6":
            limpar_tela()
            print(f"{C_CYAN}==============================================================================")
            print(f"                       ALTERAR PASTA DE TRABALHO")
            print(f"=============================================================================={C_RESET}\n")
            nova_pasta = input("Digite ou cole o caminho da nova pasta: ").strip().strip('"')
            if os.path.isdir(nova_pasta):
                pasta_atual = os.path.abspath(nova_pasta)
                print(f"\n{C_GREEN}✔ Pasta alterada com sucesso!{C_RESET}")
            else:
                print(f"\n{C_RED}✖ Caminho inválido ou diretório inexistente.{C_RESET}")
            esperar_tecla()
        elif opcao == "0":
            limpar_tela()
            print(f"\n{C_CYAN}Organizador encerrado. Até mais!{C_RESET}\n")
            break

if __name__ == "__main__":
    main()
