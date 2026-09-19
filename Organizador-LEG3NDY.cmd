@echo off
:: ==============================================================================
::  ORGANIZADOR INTELIGENTE DE ARQUIVOS — LEG3NDY Edition
::  Launcher Nativo para Windows (Compativel com Windows 10 e 11)
::  Versao: 2.1 (Suporte Completo a 21 Categorias e 150+ Extensoes)
:: ==============================================================================
title Organizador Inteligente de Arquivos - LEG3NDY Edition
mode 80,32 >nul 2>&1
chcp 65001 >nul
cls

:: Guarda o nome exato deste arquivo para nunca mover a si mesmo
set "ORGANIZADOR_SELF=%~nx0"

:: Determina a pasta onde este launcher foi aberto
set "PASTA_ALVO=%~dp0"
if "%PASTA_ALVO:~-1%"=="\" set "PASTA_ALVO=%PASTA_ALVO:~0,-1%"

:: 1. Detecta o interpretador Python (python ou py launcher nativo do Windows)
set "PY_CMD="
where python >nul 2>&1 && set "PY_CMD=python"
if not defined PY_CMD (
    where py >nul 2>&1 && set "PY_CMD=py"
)
if not defined PY_CMD (
    echo.
    echo ==============================================================================
    echo  [ERRO] O Python nao foi encontrado instalado neste computador!
    echo ==============================================================================
    echo.
    echo  Para usar o Organizador, instale o Python: https://www.python.org/downloads/
    echo  * IMPORTANTE: No instalador, marque a opcao "Add Python to PATH".
    echo.
    pause
    exit /b 1
)

:: 2. Localiza o motor organizador.py (na mesma pasta ou em locais padrao do usuario)
set "ENGINE="
if exist "%~dp0organizador.py" set "ENGINE=%~dp0organizador.py"
if not defined ENGINE if exist "%LOCALAPPDATA%\organizador-arquivos\organizador.py" set "ENGINE=%LOCALAPPDATA%\organizador-arquivos\organizador.py"
if not defined ENGINE if exist "%USERPROFILE%\organizador-arquivos\organizador.py" set "ENGINE=%USERPROFILE%\organizador-arquivos\organizador.py"

if not defined ENGINE (
    echo.
    echo ==============================================================================
    echo  [ERRO] O arquivo motor 'organizador.py' nao foi encontrado!
    echo ==============================================================================
    echo.
    echo  Certifique-se de que o arquivo 'organizador.py' esta na mesma pasta deste .cmd.
    echo.
    pause
    exit /b 1
)

:: 3. Executa o Organizador
%PY_CMD% "%ENGINE%" "%PASTA_ALVO%"

if %errorlevel% neq 0 (
    echo.
    echo Ocorreu uma finalizacao inesperada.
    echo.
    pause
)
