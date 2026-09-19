"""
Script utilitário para compilar/gerar o 'Organizador-LEG3NDY.cmd' auto-suficiente
a partir do código-fonte 'organizador.py'.
"""

import os

HEADER = (
    '@echo off & title Organizador Inteligente de Arquivos - LEG3NDY Edition & '
    'mode 80,32 >nul 2>&1 & chcp 65001 >nul & '
    '(where python >nul 2>&1 && python -x "%~f0" %* || '
    '(where py >nul 2>&1 && py -x "%~f0" %* || '
    '(echo. & echo ============================================================================== & '
    'echo  [ERRO] O Python nao foi encontrado instalado neste computador! & '
    'echo ============================================================================== & echo. & '
    'echo  Para usar o Organizador, instale o Python: https://www.python.org/downloads/ & '
    'echo  * IMPORTANTE: No instalador, marque a opcao "Add Python to PATH". & echo. & pause))) & exit /b\n'
)

def build():
    dir_atual = os.path.dirname(os.path.abspath(__file__))
    origem_py = os.path.join(dir_atual, "organizador.py")
    destino_cmd = os.path.join(dir_atual, "Organizador-LEG3NDY.cmd")

    if not os.path.exists(origem_py):
        print(f"Erro: Arquivo '{origem_py}' não encontrado.")
        return

    with open(origem_py, "r", encoding="utf-8") as f:
        codigo_python = f.read()

    conteudo_completo = HEADER + codigo_python

    with open(destino_cmd, "w", encoding="utf-8") as f:
        f.write(conteudo_completo)

    print(f"[OK] Sucesso! '{destino_cmd}' gerado como arquivo unico auto-suficiente ({len(conteudo_completo)} bytes).")

if __name__ == "__main__":
    build()
