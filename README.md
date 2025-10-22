# RDMhosting menggunakan Docker

Source code hosting terbaru bisa unduh di [Official RDMhosting Code](https://rdm.kemenag.go.id/#/download)

# Menjalankan RDMhosting dengan Docker

1. Clone repository ini (pastikan komputer sudah terinsatall docker)
2. jalankan `docker compose up --build -d`
3. lalu buka alamat `http://localhost:8080`

# Customize

- ada adminer untuk database management pengganti phpmyadmin, bisa di buka melalui `http://localhost:8080/adminer.php`
- untuk username db, nama db, dan password db bisa edit di file `compose.yaml`
