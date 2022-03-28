<template>
  <table class="correspondance-table">
    <thead>
      <tr>
        <th></th>
        <th v-for="i in 26" :key="i" :class="{currentKeyChar: currentKeyChar === (i-1)}">{{ String.fromCharCode(64 + i) }}</th>
      </tr>
    </thead>
    <tbody>
    <tr v-for="i in 26" :class="{selectedLine: currentRow === (i-1)}">
      <th :class="{currentCipherChar: currentRow === (i-1)}">{{ String.fromCharCode(65 + i - 1)}}</th>
      <td v-for="j in 26" :key="j + i*26" :class="{currentClearChar: currentRow === (i-1) && currentCipherCol === (j-1), selectedLine: currentCipherCol === (j-1)}">{{ String.fromCharCode(65 + ((i + j - 2) % 26))}}</td>
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
          currentCipherCol() {
            return this.currentKeyChar;
          },
          currentRow() {
            if(this.currentChar.type === 'clear') {
              return this.currentChar.index;
            }
            else {
              return (((26 - this.currentKeyChar) + this.currentChar.index) % 26);
            }
          },
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

  .selectedLine {
    background-color: #e9ecef;
  }

  table {
    margin-bottom: 1rem;
    letter-spacing: 0.7rem;
    line-height: 1.3rem;
    color: #212529;
  }

  table th,
  table td {
    padding: 0.10rem;
    vertical-align: top;
    border-top: 1px solid #dee2e6;
  }

  table tbody th {
    padding-right: 1rem;
  }

  table thead th {
    padding-top: 1rem;
    padding-bottom: 1rem;
    vertical-align: bottom;
    border-bottom: 2px solid #dee2e6;
  }
</style>
