#/bin/bash
rm -rf ./build/web/*
flutter build web --web-renderer canvaskit --release
scp -r ./build/web/* root@194.62.43.172:/var/www/static_sites/sunnymessage.ir
