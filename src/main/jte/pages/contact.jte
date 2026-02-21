@param String title

@template.layout.main(
    title = title,
    description = "Contact RadonVerdict for questions about our cost estimates, partnership opportunities, or media inquiries.",
    content = @`
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24">
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">Contact Us</h1>
            <p class="text-xl text-slate-600 mb-12 max-w-2xl leading-relaxed">
                Whether you're a homeowner with questions about a confusing local quote, a certified mitigation contractor wanting to join our network, or media looking for data, we're here to help.
            </p>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                <!-- Contact Options -->
                <div class="space-y-8">
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex items-start gap-4">
                        <div class="bg-indigo-50 p-3 rounded-lg text-indigo-600">
                            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                            </svg>
                        </div>
                        <div>
                            <h3 class="font-display font-bold text-lg text-slate-900 mb-1">Email Us</h3>
                            <p class="text-slate-600 mb-2 font-medium">For general inquiries, data corrections, and technical support.</p>
                            <a href="mailto:support@radonverdict.com" class="text-indigo-600 font-semibold hover:text-indigo-800">support@radonverdict.com</a>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex items-start gap-4">
                        <div class="bg-indigo-50 p-3 rounded-lg text-indigo-600">
                            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                            </svg>
                        </div>
                        <div>
                            <h3 class="font-display font-bold text-lg text-slate-900 mb-1">Partnerships & Contractors</h3>
                            <p class="text-slate-600 mb-2 font-medium">If you are a state-certified radon mitigator and want to receive leads in your service area.</p>
                            <a href="mailto:partners@radonverdict.com" class="text-indigo-600 font-semibold hover:text-indigo-800">partners@radonverdict.com</a>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex items-start gap-4">
                        <div class="bg-slate-50 p-3 rounded-lg text-slate-400">
                            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                            </svg>
                        </div>
                        <div>
                            <h3 class="font-display font-bold text-lg text-slate-900 mb-1">Office Location</h3>
                            <p class="text-slate-600 mb-2 font-medium">
                                RadonVerdict Data Analytics<br>
                                100 Innovation Drive<br>
                                Tech Hub, NY 10001
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Simple Form -->
                <div class="bg-slate-900 rounded-3xl p-8 shadow-xl text-white">
                    <h3 class="font-display font-bold text-2xl mb-4">Send us a message</h3>
                    <p class="text-slate-400 mb-6 font-medium">We usually respond within 24-48 business hours.</p>
                    
                    <form action="#" method="POST" class="space-y-4">
                        <div>
                            <label for="name" class="block text-sm font-medium text-slate-300">Name</label>
                            <input type="text" id="name" name="name" class="mt-1 block w-full rounded-lg bg-slate-800 border-slate-700 text-white shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border" placeholder="Jane Doe" required>
                        </div>
                        <div>
                            <label for="email" class="block text-sm font-medium text-slate-300">Email</label>
                            <input type="email" id="email" name="email" class="mt-1 block w-full rounded-lg bg-slate-800 border-slate-700 text-white shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border" placeholder="jane@example.com" required>
                        </div>
                        <div>
                            <label for="message" class="block text-sm font-medium text-slate-300">Message</label>
                            <textarea id="message" name="message" rows="4" class="mt-1 block w-full rounded-lg bg-slate-800 border-slate-700 text-white shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border" placeholder="How can we help?" required></textarea>
                        </div>
                        <button type="button" onclick="alert('Message sent! This is a demo form.')" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors mt-2">
                            Send Message
                        </button>
                    </form>
                </div>
            </div>
        </div>
    `
)
