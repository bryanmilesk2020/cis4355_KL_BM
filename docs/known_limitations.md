## Known Limitations

### Infrastructure Constraints
* **Cloud CDN:** Configuration requires a **Global Load Balancer**. Since this project utilizes a **Regional Load Balancer**, CDN integration was not possible.

### Cloud Armor & WAF Limitations
Cloud Armor provides robust edge protection but has specific boundaries regarding the **OWASP Top 10** and architectural security:

* **Inherent Gaps:** Cloud Armor rules cannot address:
    * Insecure designs or security misconfigurations.
    * Vulnerable and outdated components.
    * Identification, authentication, software, or data integrity failures.
    * Security logging and monitoring failures.

* **Partial Mitigation - Broken Access Control:**
    * Blocks URLs containing `/admin`.
    * Implements **rate limiting** (throttling IPs exceeding 100 requests per minute) to mitigate brute-force attempts at unauthorized URL discovery.

* **Partial Mitigation - Server-Side Request Forgery (SSRF):**
    * Blocks access to `169.254.169.254` (GCP Compute Engine metadata server).
    * **Note:** While this prevents unauthorized metadata requests at the perimeter, it cannot fully remediate SSRF vulnerabilities existing within the server-side application logic itself.
