# stable-diffusion-webui-docker

使用方法：

- docker使用N卡需要增加参数 --runtime=nvidia --gpus=all
- 本地SD的文件夹挂载到容器/config目录
- 默认开放WEB端口7860
- 增加--user="99:100" 参数解决文件权限问题，对应UID:GID
