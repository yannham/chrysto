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
      <div class="col">
        <table class="correspondance-table">
          <tbody>
          <tr>
            <td v-for="i in 26" :key="i" :class="{currentChar: currentChar === (i-1)}">{{ String.fromCharCode(64 + i)}}</td>
          </tr>
          <tr>
            <td v-for="i in 26" :key="i" :class="{currentChar: currentChar === (i-1)}">{{ subst.charAt(i-1).toUpperCase() }}</td>
          </tr>
          </tbody>
        </table>
      </div>
        <div class="col">
          <label for="clear">Texte clair</label>
          <input id="clear" v-on:keyup="updateCurrentChar" v-model="clearText"/><br>
          <label for="crypted">Texte chiffré</label>
          <input id="crypted" readonly :value="cipherText">
        </div>
    </div>
    <div class="row mt-5">
      <div class="col">
        <table class="correspondance-table">
          <tbody>
          <tr>
            <td v-for="i in 26" :key="i" :class="{currentInvChar: currentInvChar === (i-1)}">{{ String.fromCharCode(64 + i)}}</td>
          </tr>
          <tr>
            <td v-for="i in 26" :key="i" :class="{currentInvChar: currentInvChar === (i-1)}">{{
              invSubst.charAt(i-1).toUpperCase() }}</td>
          </tr>
          </tbody>
        </table>
      </div>
      <div class="col">
        <label for="clearInv">Texte clair</label>
        <input id="clearInv" v-on:keyup="updateCurrentInvChar" v-model="clearInvText"/><br>
        <label for="cryptedInv">Texte chiffré</label>
        <input id="cryptedInv" readonly :value="cipherInvText">
      </div>
    </div>
  </div>
</template>

<script>
import * as Mono from '../ocaml/mono.bs'

/**
 * Take index of a character in the alphabet between 0 and 23, and find the index of the corresponding character in a substitution represented as a string of length 26.
 * Return null if no index has been found.
 */
function findIndexOfChar(subst, code) {
  for (let i = 0; i < subst.length; i++) {
    if(subst.charCodeAt(i) - 97 === code) {
      return i;
    }
  }

  return null;
}

export default {
  name: 'ChrystoMono',
  data () {
    return {
      secretKey: "bonjour les amis",
      clearText: '',
      clearInvText: '',
      currentChar: 0,
      currentInvChar: 0,
    }
  },
  computed: {
    subst() {
      return Mono.subst_from_key(this.secretKey)
    },
    invSubst() {
      return Mono.inv(this.subst)
    },
    cipherText() {
      return Mono.encode(this.subst, this.clearText)
    },
    cipherInvText() {
      return Mono.encode(this.invSubst, this.clearInvText)
    }
  },
  methods: {
    updateCurrentChar_(e, setter) {
      const code = e.keyCode;

      if(code >= 97 && code <= 122) {
        setter(code - 97);
      }
      if(code >= 65 && code <= 90) {
        setter(code - 65);
      }
    },
    updateCurrentChar(e) {
      this.updateCurrentChar_(e,code => {
        this.currentChar = code;
        let invMaybe = findIndexOfChar(this.invSubst, code);
        if(invMaybe !== null) { this.currentInvChar = invMaybe; }
      });
    },
    updateCurrentInvChar(e) {
      this.updateCurrentChar_(e, code => {
        this.currentInvChar = code
        let invMaybe = findIndexOfChar(this.subst, code);
        if(invMaybe !== null) { this.currentChar = invMaybe; }
      });
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}

.correspondance-table {
  font-family: monospace;
  font-size: 1.25em;
}

.currentChar {
  color: red;
  font-weight: bold;
}

.currentInvChar {
  color: blue;
  font-weight: bold;
}

</style>
