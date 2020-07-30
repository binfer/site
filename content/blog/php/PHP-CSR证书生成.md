---
title: "PHP CSR证书生成"
date: 2020-07-30T11:57:03+08:00
tags: ["php"]
---

-参考:
    - https://www.jc2182.com/php/php-openssl-csr-new-ref.html
    
```php

$subject = array(
        "commonName" => "jc2182.com",
);

// Generate a new private (and public) key pair
$private_key = openssl_pkey_new(array(
        "private_key_type" => OPENSSL_KEYTYPE_EC,
        "curve_name" => 'prime256v1',
));

// Generate a certificate signing request
$csr = openssl_csr_new($subject, $private_key, array('digest_alg' => 'sha384'));

// Generate self-signed EC cert
$x509 = openssl_csr_sign($csr, null, $private_key, $days=365, array('digest_alg' => 'sha384'));
openssl_x509_export_to_file($x509, 'ecc-cert.pem');
openssl_pkey_export_to_file($private_key, 'ecc-private.key');


```

