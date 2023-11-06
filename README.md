# vizor
1. Service.sh создает сервис, который запускает task1.sh. Если всё прошло ок, отправляет сообщение в канал telegram (alert.jpg).
2. ansible_start.yml выполняет установку на удаленной машине vizor. Файлы настроек для apache и nginx (wordpress.conf и wordpress) забирает из github.
3. docker compose up -d. Запускает контейнеры mysql, wordpress и nginx. База и сам wordpress лежат рядом с compose файлом.
