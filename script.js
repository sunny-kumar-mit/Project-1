// Initialize Particles.js
particlesJS.load('particles-js', 'particles.json', function() {
    console.log('Particles.js loaded!');
});

// GSAP Scroll Animations
gsap.registerPlugin(ScrollTrigger);

gsap.from('.hero h1', {
    opacity: 0,
    y: -50,
    duration: 1,
    scrollTrigger: {
        trigger: '.hero',
        start: 'top center',
    },
});

gsap.from('.service-card', {
    opacity: 0,
    y: 50,
    stagger: 0.2,
    duration: 1,
    scrollTrigger: {
        trigger: '.services',
        start: 'top center',
    },
});