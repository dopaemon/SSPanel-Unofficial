{include file='admin/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">Thêm thông báo</h1>
        </div>
    </div>
    <div class="container">
        <div class="col-lg-12 col-md-12">
            <section class="content-inner margin-top-no">
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="content"> Nội dung </label>
                                <link rel="stylesheet"
                                      href="https://cdn.jsdelivr.net/npm/editor.md@1.5.0/css/editormd.min.css"/>
                                <div id="editormd">
                                    <textarea style="display:none;" id="content"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-10 col-md-push-1">
                                        <div class="form-group form-group-label">
                                            <label class="floating-label" for="vip">Cấp độ VIP</label>
                                            <input class="form-control maxwidth-edit" id="vip" type="text" name="vip">
                                            <p class="form-control-guide"><i class="material-icons">info</i> Gửi cho người dùng ở cấp độ này hoặc cao hơn
                                                Không được xếp hạng</p>
                                            <div class="checkbox switch">
                                                <label for="issend">
                                                    <input class="access-hide" id="issend" type="checkbox"
                                                           name="issend"><span class="switch-toggle"></span>Bạn có muốn nhận Mail không ?
                                                </label>
                                            </div>
                                        </div>
                                        <button id="submit" type="submit"
                                                class="btn btn-block btn-brand waves-attach waves-light"> Thêm
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {include file='dialog.tpl'}
            </section>
        </div>
    </div>
</main>

{include file='admin/footer.tpl'}

<script src="https://cdn.staticfile.org/editor-md/1.5.0/editormd.min.js"></script>
<script>
    (() => {
        editor = editormd("editormd", {
            path: "https://cdn.jsdelivr.net/npm/editor.md@1.5.0/lib/", // Autoload modules mode, codemirror, marked... dependents libs path
            height: 720,
            saveHTMLToTextarea: true
        });
        /*
        // or
        var editor = editormd({
            id   : "editormd",
            path : "../lib/"
        });
        */
    })();
    window.addEventListener('load', () => {
        function submit(page = -1) {
            if ($$.getElementById('issend').checked) {
                var issend = 1;
            } else {
                var issend = 0;
            }
            if (page === -1) {
                sedPage = 1;
            } else {
                sedPage = page;
            }
            $.ajax({
                type: "POST",
                url: "/admin/announcement",
                dataType: "json",
                data: {
                    content: editor.getHTML(),
                    markdown: $('.editormd-markdown-textarea').val(),
                    vip: $$getValue('vip'),
                    issend,
                    page: sedPage
                },
                success: data => {
                    if (data.ret === 1) {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        window.setTimeout("location.href=top.document.referrer", {$config['jump_delay']});
                    } else if (data.ret === 2) {
                        submit(data.msg);
                    } else {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                    }
                },
                error: jqXHR => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = `Đã xảy ra lỗi: ${
                        jqXHR.status
                    }`;
                }
            });
        }
        $$.getElementById('submit').addEventListener('click', () => {
            submit();
        });
    });
</script>
