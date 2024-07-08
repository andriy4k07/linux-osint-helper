#!/bin/bash

# Колірні коди
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Відновлення кольору

# Function to determine package management system
declare_pms() {
    if command -v apt &>/dev/null; then
        PMS="apt install -y"
    elif command -v pacman &>/dev/null; then
        PMS= " pacman -S"
    else
        echo "Unsupported package management system."
        exit 1
    fi
}

# Function to update the system on Arch Linux
update_arch() {
    if [ "$LANGUAGE" = "uk" ]; then
        echo "Оновлення системи Arch Linux..."
    else
        echo "Updating Arch Linux system..."
    fi
    sudo pacman -Syu
}

# Function to update the system on Debian/Ubuntu
update_debian() {
    if [ "$LANGUAGE" = "uk" ]; then
        echo "Оновлення системи Debian/Ubuntu..."
    else
        echo "Updating Debian/Ubuntu system..."
    fi
    sudo apt  update && sudo apt upgrade -y
}

# Function to display help
display_help() {
    if [ "$LANGUAGE" = "uk" ]; then
        echo "Використання: $0 [опції]"
        echo
        echo "Опції:"
        echo "  --skip-update         Пропустити оновлення системи."
        echo "  --language [en|uk]    Встановити мову для підказок."
        echo "  --help                Показати це повідомлення допомоги."
        echo
        echo "Для відображення справки Англійською використайте аргументи: ./linux-helper.sh --language en --help"
    else
        echo "Usage: $0 [options]"
        echo
        echo "Options:"
        echo "  --skip-update         Skip the system update."
        echo "  --language [en|uk]    Set the language for prompts."
        echo "  --help                Display this help message."
        echo
        echo "To display the manual in Ukrainian, use: ./linux-helper.sh --language uk --help"
    fi
    exit 0
}

# Default values
LANGUAGE=""
SKIP_UPDATE=false

# Call function to determine PMS(Package management system)
declare_pms

# Process command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --skip-update) SKIP_UPDATE=true ;;
        --language)
            shift
            if [[ "$1" == "en" || "$1" == "uk" ]]; then
                LANGUAGE="$1"
            else
                echo "Invalid language option. Defaulting to English."
                LANGUAGE="en"
            fi
            ;;
        --help) display_help ;;
        *) 
            echo "Unknown parameter: $1"
            display_help
            ;;
    esac
    shift
done

# Prompt for language selection if not provided by arguments
if [ -z "$LANGUAGE" ]; then
    echo -e "${GREEN}Please select a language / Будь ласка, оберіть мову:${NC}"
    echo "1. English"
    echo "2. Українська"
    read -p "Enter your choice / Введіть ваш вибір: " lang_choice
    echo

    case $lang_choice in
        1) LANGUAGE="en" ;;
        2) LANGUAGE="uk" ;;
        *)
            echo "Invalid choice, defaulting to English / Невірний вибір, за замовчуванням обрано англійську мову."
            LANGUAGE="en"
            ;;
    esac
fi

# Determine the distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        arch)
            if [ "$SKIP_UPDATE" = false ]; then
                if [ "$LANGUAGE" = "uk" ]; then
                    prompt_message="${GREEN}Бажаєте оновити систему Arch Linux? (y/n):${NC}"
                else
                    prompt_message="${GREEN}Do you want to update the Arch Linux system? (y/n):${NC}"
                fi
                read -p "$(echo -e $prompt_message)" answer
                case $answer in
                    [Yy]* ) update_arch ;;
                    [Nn]* ) 
                        if [ "$LANGUAGE" = "uk" ]; then
                            echo -e "\nОновлення системи Arch Linux пропущено.\n"
                        else
                            echo -e "\nArch Linux system update skipped.\n"
                        fi
                        ;;
                    * ) 
                        if [ "$LANGUAGE" = "uk" ]; then
                            echo -e "\nНевірний вибір. Оновлення системи Arch Linux пропущено.\n"
                        else
                            echo -e "\nInvalid choice. Arch Linux system update skipped.\n"
                        fi
                        ;;
                esac
            else
                if [ "$LANGUAGE" = "uk" ]; then
                    echo -e "\nОновлення системи Arch Linux пропущено.\n"
                else
                    echo -e "\nArch Linux system update skipped.\n"
                fi
            fi
            ;;
        debian | ubuntu)
            if [ "$SKIP_UPDATE" = false ]; then
                if [ "$LANGUAGE" = "uk" ]; then
                    prompt_message="${GREEN}Бажаєте оновити систему Debian/Ubuntu? (y/n):${NC}"
                else
                    prompt_message="${GREEN}Do you want to update the Debian/Ubuntu system? (y/n):${NC}"
                fi
                read -p "$(echo -e $prompt_message)" answer
                case $answer in
                    [Yy]* ) update_debian ;;
                    [Nn]* ) 
                        if [ "$LANGUAGE" = "uk" ]; then
                            echo -e "\nОновлення системи Debian/Ubuntu пропущено.\n"
                        else
                            echo -e "\nDebian/Ubuntu system update skipped.\n"
                        fi
                        ;;
                    * ) 
                        if [ "$LANGUAGE" = "uk" ]; then
                            echo -e "\nНевірний вибір. Оновлення системи Debian/Ubuntu пропущено.\n"
                        else
                            echo -e "\nInvalid choice. Debian/Ubuntu system update skipped.\n"
                        fi
                        ;;
                esac
            else
                if [ "$LANGUAGE" = "uk" ]; then
                    echo -e "\nОновлення системи Debian/Ubuntu пропущено.\н"
                else
                    echo -e "\nDebian/Ubuntu system update skipped.\н"
                fi
            fi
            ;;
        *)
            if [ "$LANGUAGE" = "uk" ]; then
                echo "Цей скрипт підтримує лише Arch Linux та Debian/Ubuntu."
            else
                echo "This script only supports Arch Linux and Debian/Ubuntu."
            fi
            ;;
    esac
else
    if [ "$LANGUAGE" = "uk" ]; then
        echo "Не вдалося визначити операційну систему."
    else
        echo "Failed to determine the operating system."
    fi
fi

# Install git if not already installed
if ! command -v git &>/dev/null; then
    if [ "$LANGUAGE" = "uk" ]; then
        echo "Встановлення git..."
    else
        echo "Installing git..."
    fi
    sudo "$PMS" git 
fi

# Prompt for directory creation
if [ "$LANGUAGE" = "uk" ]; then
    prompt_message="${GREEN}Бажаєте створити необхідні директорії? (y/n):${NC}"
else
    prompt_message="${GREEN}Do you want to create the necessary directories? (y/n):${NC}"
fi
read -p "$(echo -e $prompt_message)" create_dirs
echo

if [[ "$create_dirs" =~ ^[Yy]$ ]]; then
    # Prompt for directory creation location
    if [ "$LANGUAGE" = "uk" ]; then
        echo "Де ви хочете створити директорії?"
        echo "1. У поточній директорії"
        echo "2. У домашній директорії"
        read -p "Введіть ваш вибір: " dir_choice
        echo
    else
        echo "Where do you want to create the directories?"
        echo "1. In the current directory"
        echo "2. In the home directory"
        read -p "Enter your choice: " dir_choice
        echo
    fi

    case $dir_choice in
        1) BASE_DIR="." ;;
        2) BASE_DIR="$HOME" ;;
        *)
            if [ "$LANGUAGE" = "uk" ]; then
                echo "Невірний вибір, за замовчуванням обрано поточну директорію."
            else
                echo "Invalid choice, defaulting to current directory."
            fi
            BASE_DIR="."
            ;;
    esac

    mkdir -p "$BASE_DIR/tools" "$BASE_DIR/scan" "$BASE_DIR/wordlist" "$BASE_DIR/Program"
    if [ "$LANGUAGE" = "uk" ]; then
        echo "Директорії створено  $BASE_DIR"
    else
        echo "Directories created in $BASE_DIR"
    fi
fi

# Prompt for GitHub tools installation
if [ "$LANGUAGE" = "uk" ]; then
    prompt_message="${GREEN}Бажаєте встановити програми з github_link_list.txt? (y/n):${NC}"
else
    prompt_message="${GREEN}Do you want to install the programs from github_link_list.txt? (y/n):${NC}"
fi
read -p "$(echo -e $prompt_message)" install_github
echo

if [[ "$install_github" =~ ^[Yy]$ ]]; then
    if [ "$LANGUAGE" = "uk" ]; then
        HELPER_FILE="tools_install/github_links_helper_list_uk.txt"
    else
        HELPER_FILE="tools_install/github_links_helper_list_en.txt"
    fi

    if [ -f tools_install/github_link_list.txt ] && [ -f "$HELPER_FILE" ]; then
        mapfile -t github_links < tools_install/github_link_list.txt
        mapfile -t github_descriptions < "$HELPER_FILE"

        for i in "${!github_links[@]}"; do
            repo_url="${github_links[$i]}"
            description="${github_descriptions[$i]}"
            repo_name=$(basename "$repo_url" .git)
            
            if [ -d "$BASE_DIR/tools/$repo_name" ]; then
                if [ "$LANGUAGE" = "uk" ]; then
                    echo "Репозиторій $repo_name вже встановлено. Пропуск..."
                else
                    echo "Repository $repo_name is already installed. Skipping..."
                fi
                continue
            fi

            if [ "$LANGUAGE" = "uk" ]; then
                echo -e "\n${YELLOW}Інструмент:${NC} $description"
                prompt_message="${GREEN}Бажаєте встановити $repo_name? (y/n):${NC}"
            else
                echo -e "${YELLOW}Tool:${NC} $description"
                prompt_message="${GREEN}Do you want to install $repo_name? (y/n):${NC}"
            fi
            read -p "$(echo -e $prompt_message)" install_tool

            if [[ "$install_tool" =~ ^[Yy]$ ]]; then
                if [ "$LANGUAGE" = "uk" ]; then
                    echo -e "${GREEN}Клонування $repo_url у директорію tools...${NC}\n"
                else
                    echo -e "${GREEN}Cloning $repo_url into tools directory...${NC}\n"
                fi
                git clone "$repo_url" "$BASE_DIR/tools/$repo_name"
            else
                if [ "$LANGUAGE" = "uk" ]; then
                    echo -e "${RED}Пропуск встановлення $repo_name.${NC}\n"
                else
                    echo -e "${RED}Skipping installation of $repo_name.${NC}\n"
                fi
            fi
        done
    else
        if [ "$LANGUAGE" = "uk" ]; then
            echo "Файл github_link_list.txt або $HELPER_FILE не знайдено."
        else
            echo "File github_link_list.txt or $HELPER_FILE not found."
        fi
    fi
fi
