function fn() {

  var env = karate.env;
  if (!env) {
    env = 'dev';
  }

  if (env === 'dev') {
    apiPetStore = 'https://petstore.swagger.io/v2';
  } else if (env === 'cert') {

  }

  karate.log('Running tests in environment:', env);

  var config = {
    env: env,
    myVarName: 'someValue',
    apiPetStore: apiPetStore
  };



  return config;
}