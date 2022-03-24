<template>
  <div class="container">
    <div class="row mt-5">
      <div class="col"></div>
      <div class="col">
        <label for="key">Clé secrète</label>
      </div>
    </div>
    <div class="row mt-5">
      <div class="col">
        <KeyTable></KeyTable>
      </div>
    </div>
    <div class="row mt-5">
    </div>
  </div>
</template>

<script>

import KeyTable from "./KeyTable";
import * as Vigenere from '../ocaml/vigenere.bs'

export default {
  name: 'ChrystoVigenere',
  data () {
    return {
    }
  },
  components: {
    KeyTable,
  },
}
</script>

<style scoped>
.currentChar {
  color: red;
  font-weight: bold;
}

.currentInvChar {
  color: blue;
  font-weight: bold;
}

</style>
