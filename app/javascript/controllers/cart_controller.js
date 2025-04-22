// Import the Stimulus Controller base class
import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="cart"
export default class CartController extends Controller {

  // Called when the controller is initialized (when page loads with data-controller="cart")
  initialize() {
    console.log("Cart Controller Connected");
    this.displayCart(); // Load and display cart items on page load
  }

  // Display the cart items and total
  displayCart() {
    const cart = JSON.parse(localStorage.getItem("cart")) || []; // Get cart from localStorage or initialize to []

    // Clear existing cart items from the DOM to avoid duplication
    this.element.querySelectorAll(".cart-item").forEach(el => el.remove());

    const totalEl = document.getElementById("total"); // Get the element where total price is shown
    let total = 0; // Initialize total price

    // Loop through each item in the cart
    cart.forEach(item => {
      total += item.price * item.quantity; // Add item's total cost to the overall total

      // Create a card-like container for each item
      const card = document.createElement("div");
      card.classList.add("cart-item", "flex", "items-center", "bg-white", "rounded", "p-4", "shadow", "space-x-4");

      // Create an <img> element for the product image
      const img = document.createElement("img");
      img.src = item.image || "https://via.placeholder.com/80"; // Use product image or placeholder if not available
      img.alt = item.name;
      img.classList.add("w-20", "h-20", "object-cover", "rounded");

      // Create a container for text/details
      const details = document.createElement("div");
      details.classList.add("flex-1");

      // Product name
      const name = document.createElement("div");
      name.classList.add("font-semibold");
      name.innerText = item.name;

      // Size and quantity info
      const info = document.createElement("div");
      info.classList.add("text-sm", "text-gray-600", "mt-1");
      info.innerText = `Size: ${item.size} | Quantity: ${item.quantity}`;

      // Price info
      const price = document.createElement("div");
      price.classList.add("text-sm", "text-gray-800", "mt-1");
      price.innerText = `Price: ₦${(item.price * item.quantity).toLocaleString("en-NG")}`;

      // Append text elements to the details container
      details.appendChild(name);
      details.appendChild(info);
      details.appendChild(price);

      // Create the Remove button
      const removeBtn = document.createElement("button");
      removeBtn.innerText = "Remove";
      removeBtn.dataset.itemId = item.id; // Save item id in data attribute
      removeBtn.dataset.itemSize = item.size; // Save size to distinguish between variants
      removeBtn.classList.add("bg-red-500", "text-white", "rounded", "px-3", "py-1", "text-sm");
      removeBtn.addEventListener("click", this.removeFromCart.bind(this)); // Bind 'this' to ensure context

      // Add image, details, and remove button to card
      card.appendChild(img);
      card.appendChild(details);
      card.appendChild(removeBtn);

      // Insert the card before the total element
      totalEl.before(card);
    });

    // Format and display the total cost
    const formattedTotal = total.toLocaleString("en-NG", {
      style: "currency",
      currency: "NGN",
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    });

    totalEl.innerText = `Total: ${formattedTotal}`;
  } 

  // Remove a specific item from the cart
  removeFromCart(event) {
    const button = event.currentTarget;
    const id = button.dataset.itemId; // Get item ID from button
    const size = button.dataset.itemSize; // Get size to uniquely identify product

    // Sanity check
    if (!id || !size) {
      console.error("Missing item ID or size for removal.");
      return;
    }

    // Load and filter the cart
    let cart = JSON.parse(localStorage.getItem("cart")) || [];
    cart = cart.filter(item => !(item.id == id && item.size == size)); // Remove matching item

    // Save updated cart and re-render the display
    localStorage.setItem("cart", JSON.stringify(cart));
    this.displayCart();
  }

  // Clear the entire cart and reload the page
  clear() {
    localStorage.removeItem("cart"); // Delete the cart from storage
    window.location.reload(); // Reload the page to update display
  }

  // checkout(){
  //   const cart = JSON.parse(localStorage.getItem("cart"))
  //   const payload ={
  //     authenticity: "",
  //     cart: cart
  //   }

  //   const csrfToken = document.querySelector("[name='csrf-token']").content 

  //   fetch("/checkout", {
  //     method: "POST",
  //     headers: {
  //       "Content-Type": "application/json",
  //       "X-CSRF-TOKEN": csrfToken
  //     },
  //     body: JSON.stringify(payload)
  //   }).then(response => {
  //     if (response.ok) {
  //       response.json().then(body => {
  //         window.location.href = body.url
  //       })
  //     } else {
  //       response.json().then(body => {
  //         const errorEl = document.createElement("div")
  //       errorEl.innerText = `There was an error processing your order. ${body.error}`
  //       let errorContainer = document.getElementById("errorContainer")
  //       errorContainer.appendChild(errorEl)
  //       })
  //     }
  //   })
  // }
  checkout() {
    const cart = JSON.parse(localStorage.getItem("cart"));
    const payload = {
      authenticity: "",
      cart: cart
    };
  
    const csrfToken = document.querySelector("[name='csrf-token']").content;
    const checkoutButton = document.getElementById("checkout-button");
    const errorContainer = document.getElementById("errorContainer");
  
    // Disable the button and show processing text
    if (checkoutButton) {
      checkoutButton.disabled = true;
      checkoutButton.innerText = "Processing...";
      checkoutButton.classList.add("opacity-50", "cursor-not-allowed");
    }
  
    // Clear any previous errors
    if (errorContainer) {
      errorContainer.innerHTML = "";
    }
  
    fetch("/checkout", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-TOKEN": csrfToken
      },
      body: JSON.stringify(payload)
    })
      .then(response => {
        if (response.ok) {
          return response.json().then(body => {
            window.location.href = body.url; // Redirect to Stripe checkout
          });
        } else {
          return response.json().then(body => {
            const errorEl = document.createElement("div");
            errorEl.className = "text-red-600 mt-2 font-medium";
            errorEl.innerText = `There was an error processing your order. ${body.error}`;
            if (errorContainer) errorContainer.appendChild(errorEl);
            throw new Error(body.error);
          });
        }
      })
      .catch(error => {
        console.error("Checkout error:", error);
      })
      .finally(() => {
        // Re-enable the button and reset the label in case of failure
        if (checkoutButton) {
          checkoutButton.disabled = false;
          checkoutButton.innerText = "Checkout";
          checkoutButton.classList.remove("opacity-50", "cursor-not-allowed");
        }
      });
  }  
}