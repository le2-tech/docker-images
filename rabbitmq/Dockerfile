ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}rabbitmq:4-management

# https://www.rabbitmq.com/docs/mqtt
# 启用 MQTT 插件
RUN rabbitmq-plugins enable --offline rabbitmq_mqtt
