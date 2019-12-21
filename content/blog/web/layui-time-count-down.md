---
title: "Layui Time Count Down"
date: 2019-12-19T18:29:19+08:00
tags: ["web", "layui"]
---

#### ![*](https://img.shields.io/static/v1?label=smoke&message=<Layui-time-count-down>&color=green&style=for-the-badge&logo=appveyor)

#### layui 倒计时

```js

table.render({
            elem: '#withdraw-list-table'
            ,url: '/member/withdraw/list' //模拟接口
            ,method:'POST'
            ,headers: { 'X-CSRF-TOKEN': csrf_token}
            ,smartReloadModel: true
            ,totalRow:true
            ,cols: [[
                //{field: 'id',width:80,title: 'ID',sort:true}
                {field: 'member:order',width:250, title: '会员/单号',totalRowText:"总笔数"}
                ,{field: '_bank_card_number',width:200,align:"right", title: '收款银行账号'}
                ,{field: '_bank_owner_name',width:120,align:"right", title: '收款户名',totalRowText:"金额小计"}
                ,{field: 'payer_name',width:120,align:"center", title: '付款人'}
                ,{field: 'amount',align:"right", title: '金额',sort:true,width:100,totalRowText:"金额总计"}
                ,{field: 'service_charge',align:"right", title: '手续费',width:100}
                ,{field: 'create_time',align:"center", title: '申请时间',width:120}
                ,{field: 'deal_time', title: '处理时间',sort:true,width:120}
                ,{field: 'agent_pay_status_desc', align:"center",title: '业务状态',width:100}
                ,{field: 'status_desc', align:"center",title: '状态',width:100}
                ,{field: 'is_agent_pay_name',title: '出款方式',width:120}
                ,{
                    field: 'countDown',width:150, title: '确认收款倒计时', templet: function (d) {
                        return '<dev   class="layui-box layui-btn-xs countDown" data-date="' + (d.countDown||'') + '"> ---------- </dev>'
                    }
                }
                ,{field: 'lock_btn', title: '操作' ,align:"left",width:200}
                ,{field: 'operator_name', title: '操作人',width:100}
                ,{field: 'remark', title: '备注',width:200}
            ]]
            ,page: true
            ,limit: 30
            ,height: 'full-360'

           /* ,initSort: {
                field: 'deal_time' //排序字段，对应 cols 设定的各字段名
                ,type: 'desc' //排序方式  asc: 升序、desc: 降序、null: 默认排序
            }*/

            ,text: {none: '未查询到数据^_^'}
            ,done(res){
                if (res) {
                    currPage = res.curr_page || 1;
                }
                var elem = this.elem.next();
                layui.each(elem.find('.countDown'), function (index, domElem) {
                    domElem = $(domElem);
                    if (!domElem.data('date')) {
                        return;
                    }
                    //此处注意时间为毫秒
                    var endTime = new Date(domElem.data('date')).getTime(),
                        serverTime = new Date().getTime();
                    if (endTime-serverTime>=0) {
                        layui.util.countdown(endTime, serverTime, function (date, serverTime, timer) {
                            var str = '';
                            if (date[0]) {
                                str += date[0]+ '天';
                            }
                            if (date[1]) {
                                str += date[1]+ '时';
                            }
                            if (date[2]) {
                                str += date[2]+ '分'
                            }
                            if (date[3]) {
                                str += date[3]+ '秒'
                            }
                            domElem.html(str);
                        });
                    }
                });
```

