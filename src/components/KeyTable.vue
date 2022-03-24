<template>
  <table class="correspondance-table">
    <thead>
      <tr>
        <td></td>
        <td v-for="i in 26" :key="i" :class="{currentKeyChar: currentKeyChar === (i-1)}">{{ String.fromCharCode(64 + i) }}</td>
      </tr>
    </thead>
    <tbody>
    <tr v-for="i in 26">
      <td :class="{currentCipherChar: currentCipherRow === (i-1)}">{{ String.fromCharCode(65 + i - 1)}}</td>
      <td v-for="j in 26" :key="j + i*26" :class="{currentClearChar: currentClearRow === (i-1) && currentClearCol === (j-1)}">{{ String.fromCharCode(65 + ((i + j - 2) % 26))}}</td>
    </tr>
    </tbody>
  </table>
</template>

<script>
    export default {
        name: "KeyTable",
        data() {
          return {

          }
        },
        props: {
          currentKeyChar: {
            type: Number,
            default: 5,
          },
          currentChar: {
            type: Object,
            default: function () {
              return {
                type: 'cipher',
                index: 8,
              }
            },
          },
        },
        computed: {
          currentClearCol() {
              return this.currentKeyChar;
          },
          currentClearRow() {
            console.log(this.currentChar);
            console.log(this.currentKeyChar);

            if(this.currentChar.type === 'clear') {
              console.log("Returningg" + (((26 - this.currentKeyChar) + this.currentChar.index) % 26));
              return (((26 - this.currentKeyChar) + this.currentChar.index) % 26);
            }
            else {
              console.log("Returninggg" + this.currentChar.index);
              return this.currentChar.index;
            }
          },
          currentCipherRow() {
            if(this.currentChar.type === 'cipher') {
              return this.currentChar.index;
            }
            else {
              return this.currentClearRow;
            }
          }
        }
    }
</script>

<style scoped>
  .correspondance-table {
    font-family: monospace;
    font-size: 1.25em;
  }

  .currentKeyChar {
    color: red;
    font-weight: bold;
  }

  .currentClearChar {
    color: blue;
    font-weight: bold;
  }

  .currentCipherChar {
    color: violet;
    font-weight: bold;
  }
</style>
