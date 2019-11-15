rm -rf public/
HUGO_ENV=production hugo --gc --minify
# 同步图片资源到 oss
ossutilmac64 cp -r -u public/images oss://binfer/images --exclude '.DS_Store' --jobs=10
ossutilmac64 cp -r -u public/js oss://binfer/js --exclude '.DS_Store' --jobs=10
# 同步站点资源到服务器
rsync -avz --delete public/ blog:/var/www/binfer.com