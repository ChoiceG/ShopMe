// Ensure Stripe.js is loaded
const stripe = Stripe(ENV["stripe_publishable_key"]); // Replace with your actual Stripe public key

// Function to handle the checkout button click event
document.getElementById('checkout-button').addEventListener('click', function() {
    // Fetch the cart details from localStorage or your backend
    const cart = JSON.parse(localStorage.getItem("cart")) || [];

    if (cart.length === 0) {
        alert('Your cart is empty. Please add some items to your cart before checking out.');
        return;
    }

    // Calculate the total amount in kobo (1 Naira = 100 Kobo)
    let totalAmount = 0;
    cart.forEach(item => {
        totalAmount += item.price * item.quantity;
    });

    // Convert totalAmount to kobo (1 NGN = 100 Kobo)
    totalAmount = totalAmount * 100; // Total in kobo

    // Define your Stripe checkout session request
    fetch('/create-checkout-session', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            totalAmount: totalAmount, // Amount in kobo
            items: cart, // Send cart items if needed on the server side
        }),
    })
    .then(response => response.json()) // Make sure the response is parsed as JSON
    .then(sessionData => {
        if (sessionData.error) {
            alert(sessionData.error); // Handle errors from the server
        } else {
            stripe.redirectToCheckout({ sessionId: sessionData.id }).then(function(result) {
                if (result.error) {
                    alert(result.error.message); // Handle errors from Stripe Checkout
                }
            });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Something went wrong. Please try again.');
    });    
});
