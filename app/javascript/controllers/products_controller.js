// Import the base Stimulus Controller class
import { Controller } from "@hotwired/stimulus";

// Export the custom ProductsController which extends the Stimulus Controller
export default class ProductsController extends Controller {
  
  // Define reactive values: `size` (string) and `product` (object)
  static values = { size: String, product: Object }

  // Define a target element called "quantity" (this will be used in the DOM)
  static targets = ["quantity"]

  // This function runs when the "Add to Cart" button is clicked
  addToCart() {
    // Get the raw value from the quantity input field (as a string)
    const quantityRaw = this.quantityTarget.value;

    // Convert the string to a number. If invalid, default to 1
    const quantity = parseInt(quantityRaw) || 1;

    // Debugging: log both the raw input and the final parsed quantity
    console.log("📦 Quantity input:", quantityRaw);
    console.log("✅ Final parsed quantity:", quantity);

    // If the user hasn't selected a size, show an alert and exit
    if (!this.sizeValue) {
      alert("Please select a size.");
      return;
    }

    // Load the existing cart from localStorage, or use an empty array if it's not set
    let cart = JSON.parse(localStorage.getItem("cart")) || [];

    // Try to find an existing item in the cart with the same ID and size
    const foundIndex = cart.findIndex(
      item => item.id === this.productValue.id && item.size === this.sizeValue
    );

    // Get the first image from the product (or use an empty string if none)
    const imageToStore = this.productValue.images ? this.productValue.images[0] : "";

    // If the item already exists in the cart, update its quantity
    if (foundIndex >= 0) {
      cart[foundIndex].quantity += quantity;
    } else {
      // Otherwise, add a new item to the cart
      cart.push({
        id: this.productValue.id,         // Unique product ID
        name: this.productValue.name,     // Product name
        price: this.productValue.price,   // Product price
        image: imageToStore,              // Product image URL
        size: this.sizeValue,             // Selected size
        quantity: quantity                // User-selected quantity
      });
    }

    // Save the updated cart back to localStorage
    localStorage.setItem("cart", JSON.stringify(cart));

    // Notify the user
    alert("Item added to cart!");
  }

  // // This function runs when a user selects a size
  // selectSize(e) {
  //   // Set the `sizeValue` based on the clicked button's value
  //   this.sizeValue = e.target.value;

  //   // Display the selected size in the DOM (optional user feedback)
  //   const selectedSizeEl = document.getElementById("selected-size");
  //   if (selectedSizeEl) {
  //     selectedSizeEl.innerText = `Selected Size: ${this.sizeValue}`;
  //   }
  // }
  // This function runs when a user selects a size
  selectSize(e) {
    // Set the `sizeValue` based on the clicked button's value
    this.sizeValue = e.target.value;

    // Display the selected size in the DOM (optional user feedback)
    const selectedSizeEl = document.getElementById("selected-size");
    if (selectedSizeEl) {
      selectedSizeEl.innerText = `Selected Size: ${this.sizeValue}`;
    }

    // Disable the size button if the stock is exhausted
    this.updateSizeButtonsState();
  }

  // Helper function to check stock for all sizes and disable the exhausted ones
  updateSizeButtonsState() {
    // Get the available sizes for the current product
    const product = this.productValue;  // Assume this.productValue contains the product data
    const sizeButtons = document.querySelectorAll('[data-action="click->products#selectSize"]'); // Assuming buttons are marked with this action

    if (!product || !product.sizes) return; // Ensure product and sizes exist

    // Loop through all size buttons
    sizeButtons.forEach(button => {
      const size = button.value;  // Assuming each button has a `value` attribute set to the size name

      // Find the stock for this size
      const sizeData = product.sizes.find(s => s.name === size);
      
      if (sizeData && sizeData.quantity <= 0) {
        // If stock is 0 or less, disable the button
        button.disabled = true;
        button.classList.add('disabled'); // Optional: Add a disabled class for styling
      } else {
        // Enable the button if stock is available
        button.disabled = false;
        button.classList.remove('disabled'); // Remove disabled class
      }
    });
  }
}
