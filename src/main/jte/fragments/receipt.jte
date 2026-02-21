@import com.radonverdict.model.dto.CountyPageContent
@param CountyPageContent page

<!-- This div gets swapped entirely by HTMX when the form changes -->
<div id="receipt-container" class="space-y-6 animate-[fadeIn_0.5s_ease-out]">
    
    <!-- Component 1: The Receipt Card -->
    @template.components.receipt_card(receipt = page.getReceipt())
    
    <!-- Component 2: The Strategy Box -->
    @template.components.negotiation_box(page = page)

</div>

<style>
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>
