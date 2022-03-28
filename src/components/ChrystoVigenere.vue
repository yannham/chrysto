<template>
  <div class="container">
    <div class="row mt-5">
      <div class="col"></div>
      <div class="col">
        <label for="key">Clé secrète</label>
        <input id="key" v-model="secretKey">
      </div>
    </div>
    <div class="row mt-5">
      <div class="col-auto">
        <KeyTable :current-char="currentChar" :current-key-char="currentKeyChar"></KeyTable>
      </div>
      <div class="col">
        <div class="row">
          <div class="col-12">
            <label for="clear">Texte clair</label>
            <input id="clear" v-on:keyup="updateCurrentClearChar" v-model="clearText"/><br>
            <label for="crypted">Texte chiffré</label>
            <input id="crypted" readonly :value="cipherText">
          </div>
          <div class="col-12">
          <label for="clear">Texte chiffré</label>
          <input id="clear" v-on:keyup="updateCurrentCipherChar" v-model="invCipherText"/><br>
          <label for="crypted">Texte clair</label>
          <input id="crypted" readonly :value="invClearText">
        </div>
        </div>
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
      secretKey: 'Bonjour les amis',
      clearText: '',
      invCipherText: '',
      currentChar: {
        type: 'clear',
        index: 0,
      },
    }
  },
  computed: {
    cipherText() {
      return Vigenere.encode(this.key, this.clearText)
    },
    invClearText() {
      return Vigenere.decode(this.key, this.invCipherText)
    },
    key() {
      return Vigenere.key_from_string(this.secretKey)
    },
    currentKeyChar() {
      if(this.secretKey.length === 0
        || (this.currentChar.type === 'clear' && this.clearText.length === 0)
        || (this.currentChar.type === 'cipher' && this.invCipherText.length === 0)) {
        return 0;
      }

      const index = this.currentChar.type === 'clear' ? this.clearText.length-1 : this.invCipherText.length-1;
      return this.charIndex(this.secretKey.charCodeAt(index % this.secretKey.length));
    }
  },
  components: {
    KeyTable,
  },
  methods: {
    charIndex(code) {
      if(code >= 97 && code <= 122) {
        return (code - 97);
      }
      if(code >= 65 && code <= 90) {
        return (code - 65);
      }

      return null;
    },
    updateCurrentChar(e, type) {
      const index = this.charIndex(e.keyCode);

      if(index !== null) {
        this.currentChar = {
          type,
          index,
        };
      }
    },
    updateCurrentClearChar(e) {
      return this.updateCurrentChar(e, 'clear');
    },
    updateCurrentCipherChar(e) {
      return this.updateCurrentChar(e, 'cipher');
    },
  }
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
