#!/bin/bash

mkdir -p logs

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> logs/test.log
}

echo_success() {
    echo -e "${GREEN}✅  $1${NC}"
    log_message "$1"
}

echo_error() {
    echo -e "${RED}❌  $1${NC}"
    log_message "$1"
}

echo_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
    log_message "ℹ️  $1"
}

log_message "Запуск тестирования"

log_file=logs/test.log

log_message "Проверка доступа в интернет"
ping -c 4 google.com >> $log_file 2>&1
if [ $? -eq 0 ]; then
    echo_success "Интернет доступен"
else
    echo_error "Интернет не доступен"
fi

log_message "Проверка DNS"
nslookup google.com >> /dev/null 2>&1
if [ $? -eq 0 ]; then 
    echo_success "DNS работает корректно"
else 
    echo_error "Проблемы с DNS"
fi

log_message "Проверка свободного пространства"
df -h | awk 'NR>1 {print}' | while read disk free_space; do
    log_message "Disk: $disk, Free storage: $free_space"
done

log_message "Проверка целостности главного диска"
sudo fsck -n /dev/sda1 >> /dev/null 2>&1
if [ $? -eq 0 ]; then 
    echo_success "Раздел sda1 исправен"
else 
    echo_error "Проблемы с разделом sda1"
fi 

log_message "Проверка загрузки процессора"
cpu_load=$(top -bn1 | grep "Cpu(s)" | awk "{print $2}")
echo_info "Загрузка процессора ${GREEN}$cpu_load%${NC}"

