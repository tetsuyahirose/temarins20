<template lang="pug">
  v-container
    // ボタン
    v-row(no-gutters)
      v-col(cols="3" v-for="(num, i) in buttons" :key="i")
        v-btn.display-2(
          block
          height="100"
          @click="click(num)"
        )  {{num}}
    // 元に戻す・やり直す
    v-row(no-gutters)
      v-col(cols="6" v-for="(ed, i) in edits" :key="i")
        v-btn.display-1(
          block
          height="100"
          @click="moveCursor(i===0 ? -1 : 1)"
        )  {{ed}}
    // 数字表示エリア
    p.digit-area.display-3.font-weight-bold {{ inputs || calculated }}
    // デバッグ表示
    span.display-1(
      v-for="(command, i) in commands" 
      :key="i" 
      :style="`color:${i < cursor ? 'black' : 'lightgrey'}`"
    ) {{ `${command.operator}${command.num}` }}
</template>

<script lang="ts">
import { Vue, Component } from "vue-property-decorator";
import CalcCommandFactory from "../libs/calc-command-factory";
import CalcCommand from "../libs/calc-command";

@Component
export default class Calculator extends Vue {
  commands: CalcCommand[] = [];
  inputs: string = "";
  operator: string = "";
  cursor: number = 0;

  // ボタンがクリックされた時
  click(ch: string): void {
    if (ch === "C") {
      // クリア
      this.clearCommands();
    } else if (isNaN(Number(ch))) {
      // 数字以外の文字
      if (this.inputs.length > 0) {
        // 前に押されたoperatorが=だったら最初からやり直しにする
        if (this.operator === "=") {
          this.clearCommands();
        }
        const com = CalcCommandFactory.createCommand(
          this.operator,
          Number(this.inputs)
        );

        this.commands = this.commands.slice(0, this.cursor);
        this.commands.push(com);
        this.cursor++;
        this.inputs = "";
      }
      this.operator = ch;
    } else {
      // 数字
      this.inputs += ch;
    }
  }
  // 元に戻す・やり直すが押下された
  moveCursor(increment: number) {
    this.cursor += increment;
    if (this.cursor < 0) {
      this.cursor = 0;
    } else if (this.cursor > this.commands.length) {
      this.cursor = this.commands.length;
    }
  }
  // コマンドをクリア
  clearCommands(): void {
    this.commands = [];
    this.cursor = 0;
    this.operator = "";
  }
  // コマンドを計算した値を返す
  get calculated(): number {
    let ret = 0;
    for (let i = 0; i < this.commands.length && i < this.cursor; i++) {
      const com = this.commands[i];
      console.log(com);
      ret = com.calc(ret);
      console.log(ret);
    }
    return ret;
  }
  // コマンドの履歴を文字列にして返す(デバッグ用)
  get commandsHistory(): string {
    let ret = "";
    for (let i = 0; i < this.commands.length; i++) {
      const com = this.commands[i];
      ret += com.operator;
      ret += com.num;
    }
    return ret;
  }
  edits: string[] = ["元に戻す", "やり直す"];
  buttons: string[] = [
    "7",
    "8",
    "9",
    "C",
    "4",
    "5",
    "6",
    "*",
    "1",
    "2",
    "3",
    "/",
    "0",
    "=",
    "+",
    "-"
  ];
}
</script>

<style lang="sass">
.digit-area
  text-align: right
  border: solid 1px
</style>