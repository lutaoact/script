oc start-build <buildconfig_name>
oc start-build --from-build=<build_name>
oc start-build <buildconfig_name> --follow
oc start-build <buildconfig_name> --env=<key>=<value>

# https://docs.openshift.com/online/architecture/core_concepts/builds_and_image_streams.html#image-stream-tag
# Image Stream Tags: 镜像流 镜像层的栈，记录同一个tag曾经指向不同镜像记录的历史，可以回滚

一个典型的S2I流程包括如下：

1. 用户输入源代码仓库的地址。
2. 用户选择S2I构建的基础镜像（Builder镜像）。Openshift提供了多种编程语言的Builder镜像，用户也可以定制自己的Builder镜像，并发布到服务目录中。
3. 系统或用户触发S2I构建。Openshift将实例化S2I构建执行器。
4. S2I构建执行器将从用户指定的代码仓库下载源代码。
5. S2I构建执行器实例化Builder镜像，并将代码注入Builder镜像中。
6. Builder镜像将根据预定义的逻辑执行源代码的编译、构建并完成部署。
7. S2I构建执行器将完成操作的Builder镜像并生成新的Docker镜像。
8. S2I构建执行器将新的镜像推送到Openshift内部的镜像仓库中。
9. S2I构建执行器更新该次构建相关的Image Stream信息。
