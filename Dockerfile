# Amazon CorrettoのDockerイメージをベースとする
FROM amazoncorretto:21

# 作業ディレクトリを設定
WORKDIR /usr/src/app

# ホストマシンからプロジェクトのファイルをコンテナ内の作業ディレクトリにコピー
COPY . .

# Mavenのインストールに必要なパッケージをインストール
RUN yum update -y && yum install -y wget tar gzip

# Mavenをダウンロードして解凍
ENV MAVEN_VERSION 3.9.6
RUN wget https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -P /tmp && \
    tar xf /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven

# 環境変数を設定
ENV PATH="/opt/maven/bin:${PATH}"

# プロジェクトをビルド
RUN mvn clean package

# start_app.shをコンテナにコピー
COPY start_app.sh /usr/src/app/start_app.sh

# start_app.shに実行権限を付与
RUN chmod +x /usr/src/app/start_app.sh

# entrypoint.shをエントリーポイントとして設定
ENTRYPOINT ["/usr/src/app/start_app.sh"]


# アプリケーションのjarファイルを実行
# ここではビルドされたjarファイル名をyour-application.jarとしていますが、プロジェクトに合わせて変更してください
# CMD ["java", "-jar", "target/ddd-study.jar"]
