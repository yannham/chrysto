<template>
  <div id="app">
    <ChrystoMono/>
    <ChrystoVigenere/>
  </div>
</template>

<script>
import ChrystoMono from './components/ChrystoMono'
import ChrystoVigenere from "./components/ChrystoVigenere";

export default {
  name: 'App',
  components: {
    ChrystoMono,
    ChrystoVigenere,
  }
}
</script>
