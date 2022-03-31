<template>
  <div class="container">
    <h1 class="h1">Le carré de Vigenère</h1>
    <hr>
    <div class="row mt-5">
      <div class="col"></div>
      <div class="col">
        <label for="key">Clé secrète</label>
        <input id="key" v-model="secretKey">
      </div>
      <div class="col">
        <input type="radio" id="mode-encrypt" value="encrypt" v-model="mode">
        <label for="mode-encrypt">Chiffrer</label>
        <br>
        <input type="radio" id="mode-decrypt" value="decrypt" v-model="mode">
        <label for="decrypt">Déchiffrer</label>
        <br>
      </div>
    </div>
    <div class="row mt-5">
      <div class="col-auto">
        <KeyTable :current-char="currentChar" :current-key-char="currentKeyChar"></KeyTable>
      </div>
      <div class="col">
        <div class="row" v-if="mode === 'encrypt'">
          <div class="col-12">
            <label for="clear-input">Texte clair</label>
            <br>
            <textarea id="clear-input" rows="10" class="w-100" v-on:keyup="updateCurrentClearChar" v-model="clearText"/><br>
            <hr>
          </div>
          <div class="col-12">
            <label for="crypted-output">Texte chiffré</label>
            <br>
            <textarea id="crypted-output" rows="10" class="w-100" readonly :value="cipherText"/>
          </div>
        </div>
        <div class="row" v-else>
          <div class="col-12">
            <label for="crypted-input">Rappel: précédent chiffré</label>
            <br>
            <textarea id="crypted-input" rows="4" class="w-100" readonly :value="cipherText"/><br>
            <hr>
          </div>
          <div class="col-12">
            <label for="crypted-input">Texte chiffré</label>
            <br>
            <textarea id="crypted-input" rows="7" class="w-100" v-on:keyup="updateCurrentCipherChar" v-model="invCipherText"/><br>
            <hr>
          </div>
          <div class="col-12">
            <label for="clear-outpout">Texte clair</label>
            <br>
            <textarea id="clear-outpout" rows="7" class="w-100" readonly :value="invClearText"/>
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
      mode: 'encrypt',
    }
  },
  computed: {
    cipherText() {
      return Vigenere.encode(this.key, this.clearText)
    },
    invClearText() {
      return Vigenere.decode(this.key, this.invCipherText)
    },
    keyOnlyLetters() {
      return this.secretKey.replaceAll(/[^A-Za-z]/g, "");
    },
    key() {
      return Vigenere.key_from_string(this.keyOnlyLetters)
    },
    currentKeyChar() {
      if(this.keyOnlyLetters.length === 0
        || (this.currentChar.type === 'clear' && this.clearText.length === 0)
        || (this.currentChar.type === 'cipher' && this.invCipherText.length === 0)) {
        return 0;
      }

      const index = this.currentChar.type === 'clear' ? this.clearText.length-1 : this.invCipherText.length-1;
      return this.charIndex(this.keyOnlyLetters.charCodeAt(index % this.keyOnlyLetters.length));
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
</style>
