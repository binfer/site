---
title: "Temegram Php Message"
date: 2019-11-30T13:10:08+08:00
tags: ["php"]
---
#### ![*](https://img.shields.io/static/v1?label=smoke&message=<Temegram-Php-Message>&color=yellowgreen&style=for-the-badge&logo=appveyor&suffix=download&?link=http://left&link=http://google.com)

## telegram php

```php

<?php

namespace App\Repositories;


use GuzzleHttp\Client;
use GuzzleHttp\Psr7\Response;
use Illuminate\Support\Facades\Log;

// 申请bot,建立订阅通道，建立组，管理订阅通道和组，将bot拉入组内
class TelegramRepository extends BaseRepository
{

    static public $curl;
    protected $list;
    public $id, $first_name;
    public function __construct(){
        if (!self::$curl)
            self::$curl = new Client(['base_uri' => "https://api.telegram.org/bot".config('other.telegram')."/"]);
    }


    public function make() {
        $result = self::$curl->get("getUpdates", ['verify' => false]);
        $this->list = $result->getBody()->getContents();
        return $this;
    }


    public function one($index=0, $field='chat') {
        if ($this->list) {
            $data = json_decode($this->list, true);
            if (is_array($data)) {
                if (isset($data['result'][$index])) {
                    //chat针对组
                    $info = $data['result'][$index]['message'][$field];
                    foreach ($info as $k=>$v) {
                        $this->$k = $v;
                    }
                }
            }
        }
        return $this;
    }

    public function push(string $message = '', callable $call=null) {

       if ($call)$call($this);
       $msg = array(
           '位置 : '.get_called_class(),
           '时间 : '.date("Y-m-d H:i:s"),
           '事件 : '.$message
       );
       $request = [
           'query'  => [
               'chat_id'    => $this->id,
               'text'       => join(PHP_EOL,$msg),
               ],
           'verify' => false
       ];
       $result = self::$curl->post("sendMessage", $request);
       $status = $result->getStatusCode();

       if ($status != 200) Log::notice("telegram 发送失败.");

    }



    // 快捷执行
    public function execute(string $message='', int $index=0) {

        $this->make()->one($index)->push($message);
        //$this->push($message, function (&$self) use($index) {$self->make()->one($index);});

    }
}

```
