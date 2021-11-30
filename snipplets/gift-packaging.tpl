{# Product Gift Packaging - Leonam Bernini #}
{% if settings.lb_gift_packaging and settings.lb_gift_packaging_product != '' %}

    {% set gift_packaging_msg = settings.lb_gift_packaging_msg | default('Deseja incluir uma embalagem para presente?') %}
    {% set gift_packaging_msg_cta = settings.lb_gift_packaging_msg_cta | default('Sim, adicionar embalagem') %}
    <div class="js-lb-gift-packaging-options cart-row mb-4 text-center" style="display: none;" data-product="{{ settings.lb_gift_packaging_product }}">
        <p class="h5">{{ gift_packaging_msg }}</p>
        <button class="js-lb-gift-packaging-add btn btn-secondary btn-small w-100">{{ gift_packaging_msg_cta }}</button>
    </div>

{% endif %}