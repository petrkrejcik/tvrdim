module.exports = (function() {
  var env, isProduction;
  if (typeof window !== "undefined" && window !== null) {
    return window.tvr.config;
  } else {
    env = process.env.NODE_ENV;
    switch (env) {
      case 'production':
      case 'pre':
        isProduction = true;
        break;
      case 'test':
        isProduction = false;
        break;
      default:
        env = 'dev';
        isProduction = false;
    }
    return {
      env: env,
      isProduction: isProduction
    };
  }
})();
