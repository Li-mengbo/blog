<div class="copyright">{#
#}{% set current = date(Date.now(), "YYYY") %}{#
#}&copy; {% if theme.footer.since and theme.footer.since != current %}{{ theme.footer.since }} &mdash; {% endif %}{#
#}<span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.footer.icon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ theme.footer.copyright || config.author }}</span>

  {% if theme.post_wordcount.totalcount %}
    <span class="post-meta-divider">|</span>
    <span class="post-meta-item-icon">
      <i class="fa fa-area-chart"></i>
    </span>
    {% if theme.post_wordcount.item_text %}
      <span class="post-meta-item-text">{{ __('post.totalcount') }}&#58;</span>
    {% endif %}
    <span title="{{ __('post.totalcount') }}">{#
    #}{{ totalcount(site, '0,0.0a') }}{#
  #}</span>
  {% endif %}
</div>
{% if theme.busuanzi %}
  <script async src="https://busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
  <div>
    <span id="busuanzi_container_site_pv" style='display:none'>
        历经 <span id="busuanzi_value_site_pv"></span> 次回眸才与你相遇
        <span class="post-meta-divider">|</span>
    </span>
    <span id="busuanzi_container_site_uv" style='display:none'>
        我的第<span id="busuanzi_value_site_uv"></span>位朋友
    </span>
  </div>
  <script src="//cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
  <script>
      $(document).ready(function() {
          var int = setInterval(fixCount, 100);
          var busuanziSiteOffset = parseInt({{ theme.busuanzi_site_offset }});
          function fixCount() {
              if ($("#busuanzi_container_site_pv").css("display") != "none") {
                  clearInterval(int);
                  $("#busuanzi_value_site_pv").html(parseInt($("#busuanzi_value_site_pv").html()) + busuanziSiteOffset);
              }
              if ($("#busuanzi_container_site_uv").css("display") != "none") {
                  clearInterval(int);
                  $("#busuanzi_value_site_uv").html(parseInt($("#busuanzi_value_site_uv").html()) + busuanziSiteOffset);
              }
          }
      });
  </script>
{% endif %}

{% if theme.footer.custom_text %}
  <div class="footer-custom">{#
  #}{{ theme.footer.custom_text }}{#
#}</div>
{% endif %}

