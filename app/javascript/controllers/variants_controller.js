import { Controller } from "@hotwired/stimulus"

// Controla a adição dinâmica de linhas de variantes no formulário de
// calçados, clonando a primeira linha existente.
export default class extends Controller {
  connect() {
    this.template = document.querySelector("#variant-template")
  }

  addRow() {
    const container = document.querySelector("#variants")
    const row = this.template.content.cloneNode(true)
    container.appendChild(row)
  }
}