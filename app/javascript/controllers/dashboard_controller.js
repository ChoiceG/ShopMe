import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";

Chart.register(...registerables);

// Connects to data-controller="dashboard"
export default class extends Controller {
static values = { revenue: Array }

  connect() {
    console.log("Dashboard controller initialized");

    const data = this.revenueValue.map((item) => item[1])
    const labels = this.revenueValue.map((item) => item[0])

    const canvas = this.element.querySelector('#revenueChart');

    if (!canvas || !(canvas instanceof HTMLCanvasElement)) {
      console.error("Canvas element with ID 'revenueChart' not found or not a <canvas> element.");
      return;
    }

    // Destroy existing chart if already rendered
    if (canvas.chartInstance) {
      canvas.chartInstance.destroy();
    }

    const ctx = canvas.getContext('2d');
    if (!ctx) {
      console.error("Unable to get 2D context from canvas.");
      return;
    }

    const chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: 'Revenue ₦',
          data: data,
          borderWidth: 3,
          fill: true
        }]
      },
      options: {
        plugins: {
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            grid: {
              display: false
            }
          },
          y: {
            border: {
              dash: [5, 5]
            },
            grid: {
              color: "#d4f3ef"
            },
            beginAtZero: true
          }
        }
      }
    });

    // Store chart instance on canvas to clean it up later
    canvas.chartInstance = chart;
  }

  disconnect() {
    const canvas = this.element.querySelector('#revenueChart');

    if (canvas && canvas.chartInstance) {
      canvas.chartInstance.destroy();
      canvas.chartInstance = null;
    }
  }
}
