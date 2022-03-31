// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import "bootstrap"
import "bootstrap/dist/css/bootstrap.min.css"
import ChrystoMono from "./components/ChrystoMono";
import ChrystoVigenere from "./components/ChrystoVigenere"

Vue.config.productionTip = false

const routes = {
  '/': ChrystoMono,
  '/cesar': ChrystoMono,
  '/vigenere': ChrystoVigenere,
};

new Vue({
  el: '#app',
  data: {
    currentRoute: window.location.pathname
  },
  computed: {
    ViewComponent () {
      return routes[this.currentRoute] || NotFound
    }
  },
  render (h) { return h(this.ViewComponent) }
});
