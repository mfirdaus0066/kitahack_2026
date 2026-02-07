//Import from SDK
import { initializeApp } from "firebase/app";
import {
  getAuth,
  onAuthStateChanged,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
} from "firebase/auth";
import {
  getFirestore,
  collection,
  addDoc,
  onSnapshot,
  query,
  where,
  serverTimestamp,
  doc,
  updateDoc,
  deleteDoc,
} from "firebase/firestore";

// Firebase configuration
const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID
};
import './style.css';

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

// DOM
const emailInput = document.getElementById("email");
const passwordInput = document.getElementById("password");
const signinButton = document.getElementById("signin-button");
const signupButton = document.getElementById("signup-button");
const signoutButton = document.getElementById("signout-button");
const message = document.getElementById("message");

// Sign Up Logic
const signUp = async (email, password) => {
    try{
        message.innerText = "";
        message.style.color = "green";
        const userCredential = await createUserWithEmailAndPassword(auth, email, password);
        const user = userCredential.user;
        console.log("User registered:", user);
        message.innerText = "User registered successfully!";
        return user;
    }catch(error){
        console.error("Firebase Error:", error.code)
        
        message.style.color = "red";
        if (error.code === 'auth/weak-password') {
            message.innerText = "Password must be at least 6 characters long.";
        } else if (error.code === 'auth/invalid-email') {
            message.innerText = "Please enter a valid email address.";
        } else if (error.code === 'auth/email-already-in-use') {
            message.innerText = "This email is already registered.";
        } else {
            message.innerText = "An error occurred. Please try again.";
        }
    }
};

// Sign Up Event Listener
signupButton.addEventListener('click', async (e) => {
    e.preventDefault();
    const email = emailInput.value;
    const password = passwordInput.value;
    await signUp(email, password);
});

// Sign In Logic
const logIn = async (email, password) => {
    // Clear previous errors
    message.innerText = "";

    try {
        const userCredential = await signInWithEmailAndPassword(auth, email, password);
        const user = userCredential.user;
        
        console.log("Logged in as:", user.email);
        message.style.color = "green";
        message.innerText = "Login successful! Current user: " + user.email;
        
        // Optional: Redirect to a dashboard after 1 second
        // setTimeout(() => { window.location.href = "window.html"; }, 1000);

    } catch (error) {
        console.error("Login Error:", error.code);
        message.style.color = "red";
        // Common Login Errors
        switch (error.code) {
            case 'auth/invalid-credential':
                message.innerText = "Wrong email or password. Please try again.";
                break;
            case 'auth/user-not-found':
                message.innerText = "No account found with this email.";
                break;
            case 'auth/wrong-password':
                message.innerText = "Incorrect password.";
                break;
            case 'auth/invalid-email':
                message.innerText = "The email address is badly formatted.";
                break;
            case 'auth/too-many-requests':
                message.innerText = "Too many failed attempts. Try again later.";
                break;
            default:
                message.innerText = "Login failed. Please try again.";
        }
    }
};

// Sign In Event Listener
signinButton.addEventListener('click', (e) => {
    e.preventDefault(); // Stop page refresh if using a <form>
    
    const email = emailInput.value;
    const password = passwordInput.value;

    if (!email || !password) {
        message.innerText = "Please fill in all fields.";
        return;
    }

    logIn(email, password);
});

const logOut = async () => {
  try {
    await signOut(auth);
    console.log("Signed out");
  } catch (error) {
    console.error("Logout failed", error);
  }
};

signoutButton.addEventListener('click', async (e) => {
    try {
        e.preventDefault();
        await signOut(auth);
        message.style.color = "green";
        message.innerText = "Sign out successful!";
    } catch (error) {
        console.error("Signout Error:", error.code);
        message.style.color = "red";
        message.innerText = "Sign out failed. Please try again.";
    }
});