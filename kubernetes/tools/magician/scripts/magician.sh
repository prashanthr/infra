#/bin/bash
if [ -z $DEPLOYMENT_STYLE ]; then
  DEPLOYMENT_STYLE="std"
fi

function hello {
  echo -e "\nWelcome to magician! 🎩\n"
}

function run {
  echo "Deployment style: $DEPLOYMENT_STYLE"
  EXEC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  # Run app
  APP_CONFIG=$APP_CONFIG \
  K8_APP_NAMESPACE=$K8_APP_NAMESPACE
  K8_DOCKER_APP_NAME=$K8_DOCKER_APP_NAME \
  TEMPLATE_PATH=$TEMPLATE_PATH \
  SCRIPTS_PATH=$SCRIPTS_PATH \
  OUTPUT_PATH=$OUTPUT_PATH \
  $EXEC_DIR/magician-${DEPLOYMENT_STYLE}.sh
}

function fin {
  echo "Fin."
}

hello
run
fin
