from shiny import App, Inputs, Outputs, Session, render, ui

app_ui = ui.page_fluid(
    ui.output_text("headers")
)

def app_server(input: Inputs, output: Outputs, session: Session):
    @render.text
    def headers():
        headers = dict(session.http_conn.headers)  # type: ignore
        return str(headers)
    

app = App(
    app_ui,
    app_server
)