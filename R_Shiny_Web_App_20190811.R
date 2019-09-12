####################################
# R と Shiny で作る Web Application
####################################


####################################
# Chapter 1 R と Shiny の 導入
####################################

options(repos = c(RStudio = "http://rstudio.org/_packages", getOption("repos")))
#install.packages("shiny", dependencies = TRUE)

plot(x = iris$Sepal.Length, y = iris$Sepal.Width) #plot() で 散布図を描く

#install.packages("ggplot2", dependencies = TRUE)
library("ggplot2")

g <- ggplot()
g <- g + geom_point(data = iris, mapping = aes(x = Sepal.Length, y = Sepal.Width,                                               group = Species, colour = Species))
plot(g)

g <- ggplot()
g <- g + geom_histogram(data = iris, aes(Sepal.Length))
plot(g)


####################################
# Chapter 2 Shiny の 基礎講座
####################################

####################################
#app.R の場合
####################################

library(shiny)

#uiの定義
ui <- shinyUI(fluidPage(
  
  titlePanel("Old Faithful Geyser Data"),

  sidebarLayout(
    
    sidebarPanel(
      
      sliderInput("bins", "Number of bins", min = 1, max = 50, value = 30)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )  
))

#serverを定義
server <- shinyServer(function(input, output){
  
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = "darkgray", border = "white")
  })
})

#アプリの実行

shinyApp(ui = ui, server = server)

####################################
#reactive()関数
#SAMPLE CODE 03-reactive-before/ui.R
####################################

library(shiny)

ui <-shinyUI(fluidPage(
      titlePanel("Old Faithful Geyser Data"),
  
      sidebarLayout(
        sidebarPanel(
          sliderInput("bins", "Number of bins:", min = 1, max = 50, value = 30),
            selectInput("color", "select color", c("red", "blue", "green", "black"))
        ),
    
        mainPanel(plotOutput("distPlot")
                  )
    )
  )
)

server <- shinyServer(function(input, output){
  
  output$distPlot <- renderPlot({
    x = faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(faithful[, 2], breaks = bins, col = input$color, border = "white")
  })
})

shinyApp(ui = ui, server = server)

##########################
#reactive()関数
##########################
server <- shinyServer(function(input, output){
  bins <- reactive({
    x = faithful[, 2]
    return(seq(min(x), max(x), length.out = input$bins + 1))
  })
  
  output$distPlot <- renderPlot({
    hist(faithful[, 2], breaks = bins(), col = input$color, border = "white")
  })
})

shinyApp(ui = ui, server = server)

############################
#isolate()関数
############################
server <- shinyServer(function(input, output){
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(faithful[, 2], breaks = bins, col = isolate(input$color), border = "white" )
  })
})

shinyApp(ui = ui, server = server)

################################
#sample code 06-fluidRow/ui.R
################################
library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("fluid row sample"),
  fluidRow(
    column(4, sliderInput("obs_1", "Number of observation", min = 0, max = 1000, value = 500)),
    column(4, mainPanel(
      plotOutput("distPlot")
      )
      )
    )
  )
)

server <- shinyServer(function(input, output){
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs_1))
  })
})

shinyApp(ui = ui, server = server)

################################
#sample code 07-ui-widget/ui.r
################################
library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("INPUTの形式一覧"),
  
  fluidRow(
    column(4,
           h3("checkboxInput"),
           checkboxInput("checkbox",
                         "choice A",
                         value = TRUE)),
    
    column(4,
           checkboxGroupInput("checkboxGroupInput",
                              h3("checkboxGroupInput"),
                                        choices = list("choice 1" = 1,
                                                       "choice 2" = 2,
                                                       "choice 3" = 3),
                                                       selected = 1)),
    
    column(4,
           dateInput("date",
                     h3("dateInput"),
                     value = "2016-01-01"))
           ),
  
  fluidRow(
    column(4,
           dateRangeInput("dateRangeInput", h3("dateRangeInput"))),
    
    column(4,
           textInput("text", h3("textInput"),
                     value = "Enter text...")),
    
    column(4,
           numericInput("num", h3("numericinput"),
                        value = 1))
    ),
  
  fluidRow(
    column(4,
           selectInput("select", h3("selectInput"),
          choices = list("Choice 1" = 1, "choice 2" = 2,
                         "choice 3" = 3, "choice 4" = 4),
          selected = 1)),
  
  column(4, 
         sliderInput("selectInput1", h3("seleuctInput1"),
         min = 0, max = 100, value = 50),
         
         sliderInput("sliderInput2", h3("selectInput2"),
                     min = 0, max = 100, value = c(25, 75))
    )
  )
))

shinyApp(ui = ui, server = server)

################################
#sample code 08-ui-widget/ui.r
################################

library(shiny) 

ui <- shinyUI(
  fluidPage(
    
    titlePanel("Old Faithful Geyser Data"), 
    sidebarLayout(
    
      sidebarPanel(
        sliderInput("bins", 
        "Number of bins:", min = 1, max = 50, value = 30), # カンマを追加 
        img(src = "sample.jpg", height = 70, width = 90) # ここを一行追加 
        ), 
    
    mainPanel(
      
      plotOutput("distPlot") 
    ) 
  ) 
)) 

shinyApp(ui = ui, server = server)

################################
#sample code 09-ui-widget/ui.r
################################
library(shiny)

ui <- shinyUI(fluidPage(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")), #ここを追加
    titlePanel("Old Faituful Geyser Data"),
  
    sidebarLayout(
      sidebarPanel(
        sliderInput("bins",
                    "Number of bins",
                    min = 1, max = 90, value = 30),
        img(src = "sample.jpg", height = 70, width = 90)
      ),
    
      mainPanel(
        plotOutput("distPlot")
      )
    )
))

shinyApp(ui = ui, server = server)

################################
#sample code 09-ui-widget/ui.r
################################

library(shiny)

ui <- shinyUI(fluidPage(
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
            tags$script(src = "color_change.js")), #追加
  titlePanel("Old Faituful Geyser Data"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1, max = 50, value = 30),
      img(src = "sample.jpg", height = 70, width = 90),
      #以下追加
      a(href = "javascript:changeBG('red')", "赤"),
      a(href = "javascript:changeBG('blue')", "青"),
      a(href = "javascript:changeBG('green')", "緑"),
      a(href = "javascript:changeBG('#b0c4de')", "リセット")
    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
))

shinyApp(ui = ui, server = server)

##################################################################
# Chapter 03 回帰/分類/クラスタリングを行う shiny アプリケーション
##################################################################

################################
#01-navbar/ui.R
################################
library(shiny)

ui <- shinyUI(navbarPage("title",
                         tabPanel("subtitle1", h1("1つ目のページ")),
                         tabPanel("subtitle2", h1("２つ目のページ")),
                         navbarMenu("subtitle3",
                                    tabPanel("subsubtitle1",
                                             h1("ドロップダウンメニュー1つ目のページ")),
                                    tabPanel("subsubtitle2",
                                             h1("ドロップダウンメニュー2つ目のページ")))
                         ))

shinyApp(ui = ui, server = server)

################################
#02-navbar/ui.R
################################
library(shiny)

ui <- shinyUI(navbarPage("title",
                         tabPanel("subtitle1", h1("1つ目のページ")),
                         tabPanel("subtitle2", h1("２つ目のページ")),
                         navbarMenu("subtitle3",
                                    tabPanel("subsubtitle1",
                                             h1("ドロップダウンメニュー1つ目のページ")),
                                    tabPanel("subsubtitle2",
                                             h1("ドロップダウンメニュー2つ目のページ"))),
                         header = h2("header test"), footer = h3("footer test")
))

shinyApp(ui = ui, server = server)

################################
#03-navbar/ui.R
################################
library(shiny)

ui <- shinyUI(navbarPage("title",
                         tabPanel("subtitle1", h1("1つ目のページ")),
                         tabPanel("subtitle2", h1("２つ目のページ")),
                         navbarMenu("subtitle3",
                                    tabPanel("subsubtitle1",
                                             h1("ドロップダウンメニュー1つ目のページ")),
                                    tabPanel("subsubtitle2",
                                             h1("ドロップダウンメニュー2つ目のページ"))),
                         header = h2("header test"), footer = h3("footer test"),
                         position = "fixed-bottom"
))

shinyApp(ui = ui, server = server)

################################
#04-navbar/ui.R
################################
library(shiny)

ui <- shinyUI(
  navbarPage("Shinyサンプルアプリケーション",
             tabPanel("Home",
                      h1("『RとShinyで作るWebアプリケーション』のサンプルアプリケーション"),
                      h2("アプリケーション概要"),
                      p("オープンソースデータを用いて可視化と分析を行えるshinyアプリです。"),
                      helpText("サンプルなので、うまく動かない可能性もあるのでご注意ください。")),
             tabPanel("Shinyとは?",
                      h1("Shinyでは以下のようなアプリケーションが作成できます。")),
             tabPanel("可視化"),
             tabPanel("回帰"),
             tabPanel("分類"),
             tabPanel("クラスタリング"),
             navbarMenu("その他",
                        tabPanel("About", h2("私の名前はNp-Urです。")),
                        tabPanel("ソースコード"),
                        a(href = "https://github.com/Np-Ur/ShinyBook",
                          p("https://github.com/Np-Ur/ShinyBook"))))
)

shinyApp(ui = ui, server = server)

################################
# 05-html/ui.R
################################
library(shiny)

ui <- shinyUI(fluidPage(
  
  titlePanel("タイトルです。"),
  
  sidebarLayout(
    sidebarPanel(
      h1("h1タグを使って大見出し"),
      div("div関数を使っています。",
          br(),
          "開業を入れています。",
          p("p関数で段落を作っています。")
          )
    ),
    mainPanel(
      h2("h2タグを使って見出し。"),
      h3("h3タグを使って見出し"),
      h4("h4タグを使って見出し"),
      h5("h5タグを使って見出し"),
      h6("h6タグを使って見出し"),
      a(href = "https://www.rsudio.com/", "RStudioへのリンク"),
      p("普通のテキスト",
      strong("強調されたテキスト"))
    )
  )
))

shinyApp(ui = ui, server = server)

#################################
# 06-tabsetPanel/ui.R
#################################
library(shiny)

ui <- shinyUI(
  fluidPage(
    titlePanel("タイトル"),
    
    sidebarLayout(
      sidebarPanel(
        sliderInput("bins",
                    "Number of bins:",
                    min = 1, max = 50, value = 30)
      ),
      
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Plot", plotOutput("distPlot")),
                    tabPanel("Table", plotOutput("table"))
                    )
      )
    )
  )
)

server <- shinyServer(function(input, output){
  
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = "white")
  })
  
  output$table <- renderTable({
    faithful[, 2]
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 07-app-version 1.1 / ui.R
#####################################
#install.packages("shinythemes")

library(shiny)
library(shinythemes)

ui <- shinyUI(
  navbarPage("Shinyサンプルアプリケーション",
             tabPanel("Home",
                      h1("『RとShinyで作るwebアプリケーション』のサンプルアプリケーション"),
                      h2("アプリケーション概要"),
                      p("オープンソースデータを用いて可視化と分析を行えるShinyアプリです。"),
                      helpText("サンプルなので、うまく動かない可能性もあるのでご注意ください。")),
             
             tabPanel("Shinyとは?",
                      h1("Shinyでは以下のようなアプリケーションが作成できます。"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("bins_shiny",
                                      "Number od bins:",
                                      min = 1, max = 50, value = 30)
                        ),
                        mainPanel(
                          plotOutput("distPlot_shiny")
                        )
                      ),
                      
                      tabPanel("可視化", sidebarLayout(
                        sidebarPanel(),
                        mainPanel(
                          tabsetPanel(type = "tabs", 
                                      tabPanel("Table"),
                                      tabPanel("ヒストグラム"),
                                      tabPanel("散布図"),
                                      tabPanel("みたいにほかにも図を表示する。")
                                      )
                        )
                      )),
                      
                      tabPanel("回帰", sidebarLayout(
                        sidebarPanel(),
                        mainPanel(
                          tabsetPanel(type = "tabs",
                                      tabPanel("回帰結果"),
                                      tabPanel("プロットで結果を確認")
                                      )
                        )
                      )),
                      
                      tabPanel("クラスタリング", sidebarLayout(
                        sidebarPanel(),
                        mainPanel(
                          tabsetPanel(type = "tabs",
                                      tabPanel("クラスタリング結果"),
                                      tabPanel("プロットで結果を確認")
                                      )
                        )
                      )),
                      
                      navbarMenu("その他",
                                 tabPanel("About",
                                          h2("私の名前はNp-Urです。")),
                                 tabPanel("ソースコード",
                                          a(href = "https://github.com/Np-Ur/ShinyBook",
                                            p("https://github.com/Np-Ur/ShinyBook"))
                                          )
                                 )
                      )
             )
)

server <- shinyServer(function(input, output){
  output$distPlot_shiny <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins_shiny + 1)
    hist(x, breaks = bins, col = "darkgray", border = 'white')
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 08-themeSelector / ui.R
#####################################
library(shiny)
library(shinythemes)

ui <- shinyUI(
  tagList(shinythemes::themeSelector(),
          navbarPage("shinythemes サンプル",
                     tabPanel("ページ1", sidebarLayout(
                       sidebarPanel(
                         sliderInput("bins", "Number of bins",
                                      min = 0, max = 50, value = 30)
                       ),
                       mainPanel(
                         tabsetPanel(type = "tabs",
                                     tabPanel("Plot", plotOutput("distPlot")),
                                     tabPanel("Table", tableOutput("table"))
                                     )
                       )
                     )),
                     tabPanel("ページ2",
                              h2("テキスト")),
                     navbarMenu("自己紹介", 
                                tabPanel("名前", h2("私の名前は Np-Ur です。")),
                                tabPanel("好きな食べ物", h2("私は寿司が好きです。"))
                                )
                     )
          )
)

server <- shinyServer(function(input, output){
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$table <- renderTable({
    faithful[, 2]
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 09-themeSelector / ui.R
#####################################
library(shiny)
library(shinythemes)

ui <- shinyUI(
  #tagList(shinythemes::themeSelector(),
          navbarPage("shinythemes サンプル",
                     theme = shinytheme("cerulean"), #追加
                     tabPanel("ページ1", sidebarLayout(
                       sidebarPanel(
                         sliderInput("bins", "Number of bins",
                                     min = 0, max = 50, value = 30)
                       ),
                       mainPanel(
                         tabsetPanel(type = "tabs",
                                     tabPanel("Plot", plotOutput("distPlot")),
                                     tabPanel("Table", tableOutput("table"))
                         )
                       )
                     )),
                     
                     tabPanel("ページ2",
                              h2("テキスト")),
                     navbarMenu("自己紹介", 
                                tabPanel("名前", h2("私の名前は Np-Ur です。")
                                         ),
                                tabPanel("好きな食べ物", h2("私は寿司が好きです。")
                                         )
                   )
        )
)

shinyApp(ui = ui, server = server)

#####################################
# 10-themeSelector / ui.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("selectInputの例",
             sidebarLayout(
               sidebarPanel(
                 selectInput("selectInputId",
                             "何か選択してください。",
                             choices = c("東京" = "Tokyo",
                                         "茨城" = "Ibaraki",
                                         "群馬" = "gumma")
                             )
               ),
               
               mainPanel(
                 textOutput("text")
               )
             )
          )
))

server <- shinyServer(function(input, output){
  
  output$text <- renderText({
    paste("あなたが選択したのは", input$selectInputID, "です。")
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 11-app-version2.0 / ui.R
#####################################
#install.packages("kernlab")
library(shiny)
library(shinythemes)
library(shiny)
library(MASS)
library(kernlab)
data(spam)

ui <- shinyUI(
          navbarPage("Shinyサンプルアプリケーション",
             tabPanel("Home",
                      h1("『RとShinyで作るWebアプリケーション』のサンプルアプリケーション"),
                      h2("アプリケーション概要"),
                      p("オープンソースデータを用いて可視化と分析を行えるShinyアプリです。"),
                      helpText("サンプルなので、うまく動かない可能性もあるのでご注意ください。")),
             
             tabPanel("Shinyとは?",
                      h1("Shinyでは以下のようなアプリケーションが作成できます。"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("bins_shiny",
                                      "Number of bins:",
                                      min = 1,
                                      max = 50,
                                      value = 30)
                        ),
                        mainPanel(
                          plotOutput("distPlot_shiny")
                        )
                      )
             ),
             
             tabPanel("可視化", sidebarLayout(
               sidebarPanel(
                 # 下記部分を追加
                 selectInput("selected_data_for_plot", label = h3("データセットを選択してください。"),
                             choices = c("アヤメのデータ" = "iris",
                                         "不妊症の比較データ" = "infert",
                                         "ボストン近郊の不動産価格データ" = "Boston",
                                         "スパムと正常メールのデータ" = "spam",
                                         "ニューヨークの大気状態データ" = "airquality",
                                         "タイタニックの乗客データ" = "titanic"),
                             selected = "iris")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table",
                                      tableOutput("table_for_plot")),
                             tabPanel("ヒストグラム"),
                             tabPanel("散布図"),
                             tabPanel("みたいに他にも図を表示する")
                 )
               )
             )),
             
             tabPanel("回帰", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("回帰結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("分類", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("分類結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("クラスタリング", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("クラスタリング結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             navbarMenu("その他",
                        tabPanel("About",
                                 h2("私の名前はNp-Urです。")),
                        tabPanel("ソースコード",
                                 a(href="https://github.com/Np-Ur/ShinyBook", 
                                   p("https://github.com/Np-Ur/ShinyBook"))
                        )
             )
  )
)


server <- shinyServer(function(input, output) {
  output$distPlot_shiny <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins_shiny + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  data_for_plot <- reactive({
    switch(input$selected_data_for_plot,
           "iris" = iris,
           "infert" = infert,
           "Boston" = Boston,
           "spam" = spam,
           "airquality" = airquality,
           "titanic" = data.frame(lapply(data.frame(Titanic), 
                                         function(i){rep(i, data.frame(Titanic)[, 5])}))
    )
  })
  
  output$table_for_plot <- renderTable({
    data_for_plot()
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 12-app-version2.1 / ui.R
#####################################
library(shiny)
library(shinythemes)
library(DT)

ui <- shinyUI(
            navbarPage("Shinyサンプルアプリケーション",
             tabPanel("Home",
                      h1("『RとShinyで作るWebアプリケーション』のサンプルアプリケーション"),
                      h2("アプリケーション概要"),
                      p("オープンソースデータを用いて可視化と分析を行えるShinyアプリです。"),
                      helpText("サンプルなので、うまく動かない可能性もあるのでご注意ください。")),
             
             tabPanel("Shinyとは?",
                      h1("Shinyでは以下のようなアプリケーションが作成できます。"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("bins_shiny",
                                      "Number of bins:",
                                      min = 1,
                                      max = 50,
                                      value = 30)
                        ),
                        mainPanel(
                          plotOutput("distPlot_shiny")
                        )
                      )
             ),
             
             tabPanel("可視化", sidebarLayout(
               sidebarPanel(
                 selectInput("selected_data_for_plot", label = h3("データセットを選択してください。"),
                             choices = c("アヤメのデータ" = "iris",
                                         "不妊症の比較データ" = "infert",
                                         "ボストン近郊の不動産価格データ" = "Boston",
                                         "スパムと正常メールのデータ" = "spam",
                                         "ニューヨークの大気状態データ" = "airquality",
                                         "タイタニックの乗客データ" = "titanic"),
                             selected = "iris")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table",
                                      DT::dataTableOutput("table_for_plot")),
                             tabPanel("ヒストグラム"),
                             tabPanel("散布図"),
                             tabPanel("みたいに他にも図を表示する")
                 )
               )
             )),
             
             tabPanel("回帰", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("回帰結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("分類", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("分類結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("クラスタリング", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("クラスタリング結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             navbarMenu("その他",
                        tabPanel("About",
                                 h2("私の名前はNp-Urです。")),
                        tabPanel("ソースコード",
                                 a(href="https://github.com/Np-Ur/ShinyBook", 
                                   p("https://github.com/Np-Ur/ShinyBook"))
                        )
             )
  )
)

server <- shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  data_for_plot <- reactive({
    switch(input$selected_data_for_plot,
           "iris" = iris,
           "infert" = infert,
           "Boston" = Boston,
           "spam" = spam,
           "airquality" = airquality,
           "titanic" = data.frame(lapply(data.frame(Titanic), 
                                         function(i){rep(i, data.frame(Titanic)[, 5])}))
    )
  })
  
  output$table_for_plot <- DT::renderDataTable({
    data_for_plot()
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 13-numericInput / ui.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  
  titlePanel("numericInput"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("numericInput_data",
                   "irisデータでヒストグラムを表示する列番号",
                   min = 1, max = 5, value = 1),
      sliderInput("sliderInput_data", 
                  "Number of bins:",
                  min = 1, max = 50, value = 30)
    ),
    
    mainPanel(
      plotOutput("plot")
    )
  )
))

server <- shinyServer(function(input, output){
  output$plot <- renderPlot({
    x <- iris[, input$numericInput_data]
    bins <- seq(min(x), max(x), length.out = input$sliderInput_data + 1)
    hist(x, breaks = bins, col = "darkgray", border = "white")
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 14-updateSelectInput / ui.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  
  titlePanel("opdateSelectInput"),
  
  radioButtons("input_radio_button", "Input radioButtons",
               c("Tokyo", "Gumma", "Ibaraki"), selected = "Tokyo"),
  selectInput("choices", "Select input", 
              c("Tokyo", "Gumma", "Ibaraki"))
))

server <- shinyServer(function(input, output, session){
  observe({
    if (input$input_radio_button == "Tokyo") {
      choiceList = c("Shinjuku", "Shibuya", "Shinagawa")
    } else if (input$input_radio_button == "Gumma") {
      choiceList = c("Maebashi", "Takasaki", "Kiryu")
    } else {
      choiceList = c("Mito", "Tsuchiura", "Tsukuba")
    }
    
    updateSelectInput(session, "choices",
                      label = "Select input label",
                      choices = choiceList)
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 15-app-version 2.2 / ui.R
#####################################
library(shiny)
library(shinythemes)
library(DT)

ui <- shinyUI(
  navbarPage("Shinyサンプルアプリケーション",
             tabPanel("Home",
                      h1("『RとShinyで作るWebアプリケーション』のサンプルアプリケーション"),
                      h2("アプリケーション概要"),
                      p("オープンソースデータを用いて可視化と分析を行えるShinyアプリです。"),
                      helpText("サンプルなので、うまく動かない可能性もあるのでご注意ください。")),
             
             tabPanel("Shinyとは?",
                      h1("Shinyでは以下のようなアプリケーションが作成できます。"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("bins_shiny",
                                      "Number of bins:",
                                      min = 1,
                                      max = 50,
                                      value = 30)
                        ),
                        mainPanel(
                          plotOutput("distPlot_shiny")
                        )
                      )
             ),
             
             tabPanel("可視化", sidebarLayout(
               sidebarPanel(
                 selectInput("selected_data_for_plot", label = h3("データセットを選択してください。"),
                             choices = c("アヤメのデータ" = "iris",
                                         "不妊症の比較データ" = "infert",
                                         "ボストン近郊の不動産価格データ" = "Boston",
                                         "スパムと正常メールのデータ" = "spam",
                                         "ニューヨークの大気状態データ" = "airquality",
                                         "タイタニックの乗客データ" = "titanic"),
                             selected = "iris"),
                 selectInput("select_input_data_for_hist",
                             "ヒストグラムを表示する列番号",
                             choices = colnames(iris)),
                 sliderInput("slider_input_data",
                             "Number of bins:",
                             min = 1,
                             max = 50,
                             value = 30)
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table",
                                      DT::dataTableOutput("table_for_plot")),
                             tabPanel("ヒストグラム", plotOutput("histgram")),
                             tabPanel("散布図"),
                             tabPanel("みたいに他にも図を表示する")
                 )
               )
             )),
             
             tabPanel("回帰", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("回帰結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("分類", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("分類結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("クラスタリング", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("クラスタリング結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             navbarMenu("その他",
                        tabPanel("About",
                                 h2("私の名前はNp-Urです。")),
                        tabPanel("ソースコード",
                                 a(href="https://github.com/Np-Ur/ShinyBook", 
                                   p("https://github.com/Np-Ur/ShinyBook"))
                        )
             )
  )
)

server <- shinyServer(function(input, output, session) {
  output$distPlot_shiny <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins_shiny + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  data_for_plot <- reactive({
    data <- switch(input$selected_data_for_plot,
                   "iris" = iris,
                   "infert" = infert,
                   "Boston" = Boston,
                   "spam" = spam,
                   "airquality" = airquality,
                   "titanic" = data.frame(lapply(data.frame(Titanic), 
                                                 function(i){rep(i, data.frame(Titanic)[, 5])}))
    )
    updateSelectInput(session, "select_input_data_for_hist", choices = colnames(data))
    return(data)
  })
  
  output$histgram <- renderPlot({
    tmpData <- data_for_plot()[, input$select_input_data_for_hist]
    x <- na.omit(tmpData)
    bins <- seq(min(x), max(x), length.out = input$slider_input_data + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$table_for_plot <- DT::renderDataTable({
    data_for_plot()
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 16-actionbutton / ui.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  
  titlePanel("actionButton"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1, max = 50, value = 30),
      actionButton("do", "プロットを実行")
    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
))

server <- shinyServer(function(input, output){
  x <- faithful[, 2]
  bins <- eventReactive(input$do, {
    seq(min(x), max(x), length.out = input$bins + 1)
  })
  
  output$distPlot <- renderPlot({
    hist(x, breaks = bins(), col = "darkgray", border = "white")
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 17-actionbutton2 / server.R
#####################################
library(shiny)

server <- shinyServer(function(input, output){
  output$distPlot <- renderPlot({
    input$do
    
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = isolate(input$bins) + 1)
    hist(x, breaks = bins, col = "darkgray", border = "white")
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 18-app-version2.3 / ui.R
#####################################
library(shiny)
library(shinythemes)
library(DT)
library(MASS)
library(kernlab)
data(spam)


ui <- shinyUI(
            navbarPage("Shinyサンプルアプリケーション",
             tabPanel("Home",
                      h1("『RとShinyで作るWebアプリケーション』のサンプルアプリケーション"),
                      h2("アプリケーション概要"),
                      p("オープンソースデータを用いて可視化と分析を行えるShinyアプリです。"),
                      helpText("サンプルなので、うまく動かない可能性もあるのでご注意ください。")),
             
             tabPanel("Shinyとは?",
                      h1("Shinyでは以下のようなアプリケーションが作成できます。"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("bins_shiny",
                                      "Number of bins:",
                                      min = 1,
                                      max = 50,
                                      value = 30)
                        ),
                        mainPanel(
                          plotOutput("distPlot_shiny")
                        )
                      )
             ),
             
             tabPanel("可視化", sidebarLayout(
               sidebarPanel(
                 selectInput("selected_data_for_plot", label = h3("データセットを選択してください。"),
                             choices = c("アヤメのデータ" = "iris",
                                         "不妊症の比較データ" = "infert",
                                         "ボストン近郊の不動産価格データ" = "Boston",
                                         "スパムと正常メールのデータ" = "spam",
                                         "ニューヨークの大気状態データ" = "airquality",
                                         "タイタニックの乗客データ" = "titanic"),
                             selected = "iris"),
                 selectInput("select_input_data_for_hist",
                             "ヒストグラムを表示する列番号",
                             choices = colnames(iris)),
                 sliderInput("slider_input_data",
                             "Number of bins:",
                             min = 1,
                             max = 50,
                             value = 30),
                 actionButton("trigger_histogram", "ヒストグラムを出力")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table",
                                      DT::dataTableOutput("table_for_plot")),
                             tabPanel("ヒストグラム", plotOutput("histgram")),
                             tabPanel("散布図"),
                             tabPanel("みたいに他にも図を表示する")
                 )
               )
             )),
             
             tabPanel("回帰", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("回帰結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("分類", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("分類結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("クラスタリング", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("クラスタリング結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             navbarMenu("その他",
                        tabPanel("About",
                                 h2("私の名前はNp-Urです。")),
                        tabPanel("ソースコード",
                                 a(href="https://github.com/Np-Ur/ShinyBook", 
                                   p("https://github.com/Np-Ur/ShinyBook"))
                        )
             )
  )
)

server <- shinyServer(function(input, output, session) {
  output$distPlot_shiny <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins_shiny + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  data_for_plot <- reactive({
    data <- switch(input$selected_data_for_plot,
                   "iris" = iris,
                   "infert" = infert,
                   "Boston" = Boston,
                   "spam" = spam,
                   "airquality" = airquality,
                   "titanic" = data.frame(lapply(data.frame(Titanic), 
                                                 function(i){rep(i, data.frame(Titanic)[, 5])}))
    )
    updateSelectInput(session, "select_input_data_for_hist", choices = colnames(data))
    return(data)
  })
  
  output$histgram <- renderPlot({
    input$trigger_histogram
    
    tmpData <- data_for_plot()[, isolate(input$select_input_data_for_hist)]
    x <- na.omit(tmpData)
    bins <- seq(min(x), max(x), length.out = isolate(input$slider_input_data) + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$table_for_plot <- DT::renderDataTable({
    data_for_plot()
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 19-scatter-plot / server.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("scatter plot"),
  sidebarLayout(
    sidebarPanel(
      h4("散布図を表示する列を指定"),
      selectInput("input_data_for_scatter_plotX",
                  "x軸",
                  choices = colnames(iris), selected = colnames(iris)[1]),
      selectInput("input_data_for_scatter_plotY",
                  "y軸",
                  choices = colnames(iris), selected = colnames(iris)[1]),
      actionButton("trigger_scatter_plot", "散布図を出力")
    ),
    mainPanel(
      plotOutput("scatter_Plot")
    )
  )
))

server <- shinyServer(function(input, output){
  data <- reactive({
    iris[, c(input$input_data_for_scatter_plotX, input$input_data_for_scatter_plotY)]
  })
  
  output$scatter_plot <- renderPlot({
    input$trigger_scatter_Plot
    plot(isolate(data()))
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 20-dslclickOpts / ui.R
#####################################
#install.packages("DT")
library(shiny)

ui <- shinyUI(fluidPage(
  
  titlePanel("scatter plot"),
  
  sidebarLayout(
    sidebarPanel(
      h4("散布図を表示する列を指定"),
      selectInput("input_data_for_scatter_plotX",
                  "x軸",
                  choices = colnames(iris), selected = colnames(iris)[1]),
      selectInput("input_data_for_scatter_plotY",
                  "y軸",
                  choices = colnames(iris), selected = colnames(iris)[1]),
      actionButton("trigger_scatter_plot", "散布図を出力")
    ),
    
    mainPanel(
      plotOutput("scatterPlot", dblclick = dblclickOpts(id = "plot_dbl_click")),
      verbatimTextOutput("plot_dbl_click_info"),
      DT::dataTableOutput("plot_clickedpoints")
    )
  )
))

server <- shinyServer(function(input, output){
  data <- reactive({
    iris[, c(input$input_data_for_scatter_plotX, input$input_data_scatter_plotY)]
  })
  
  output$scatter_plot <- renderPlot({
    input$trigger_scatter_plot
    plot(isolate(data()))
  })
  
  output$plot_dbl_click_info <- renderPrint({
    cat("ダブルクリックした箇所の情報:\n")
    str(input$plot_dbl_click)
  })
  
  output$plot_clickedpoint <- DT::renderDataTable({
    res <- nearPoints(iris, input$plot_dbl_click, xvar = input$input_data_for_scatter_plotX,
                      yvar = input$input_data_for_scatter_plotY,
                      threshold = 5, maxpoints = 10)
    
    if (nrow(res) == 0)
      return()
      res
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 21-brushOpts / ui.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  
  titlePanel("scatter plot"),
  
  sidebarLayout(
    sidebarPanel(
      h4("散布図を表示する列を指定"),
      selectInput("input_data_for_scatter_plotX",
                  "x軸",
                  choices = colnames(iris), selected = colnames(iris)[1]),
      selectInput("input_data_for_scatter_plotY",
                  "y軸",
                  choices = colnames(iris), selected = colnames(iris)[1]),
      actionButton("trigger_scatter_plot", "散布図を出力")
    ),
    mainPanel(
      plotOutput("scatter_plot", brush = brushOpts(id="plot_brush")),
      verbatimTextOutput("plot_brush_info"),
      DT::dataTableOutput("plot_brushedpoints")
    )
  )
))

library(shiny)

server <- shinyServer(function(input, output) {
  data <- reactive({
    iris[, c(input$input_data_for_scatter_plotX, input$input_data_for_scatter_plotY)]
  })
  
  output$scatter_plot <- renderPlot({
    input$trigger_scatter_plot
    plot(isolate(data()))
  })
  
  output$plot_brush_info <- renderPrint({
    cat("ダブルクリックした箇所の情報:\n")
    str(input$plot_brush)
  })
  
  output$plot_brushedpoints <- DT::renderDataTable({
    res <-  brushedPoints(iris, input$plot_brush, 
                          xvar = input$input_data_for_scatter_plotX,
                          yvar = input$input_data_for_scatter_plotY)
    
    if (nrow(res) == 0)
      return()
    res
  })
})


shinyApp(ui = ui, server = server)

#####################################
# 22-app-version2.4 / ui.R
#####################################
library(shiny)
library(shinythemes)
library(DT)

ui <- shinyUI(
  navbarPage("Shinyサンプルアプリケーション",
             tabPanel("Home",
                      h1("『RとShinyで作るWebアプリケーション』のサンプルアプリケーション"),
                      h2("アプリケーション概要"),
                      p("オープンソースデータを用いて可視化と分析を行えるShinyアプリです。"),
                      helpText("サンプルなので、うまく動かない可能性もあるのでご注意ください。")),
             
             tabPanel("Shinyとは?",
                      h1("Shinyでは以下のようなアプリケーションが作成できます。"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("bins_shiny",
                                      "Number of bins:",
                                      min = 1,
                                      max = 50,
                                      value = 30)
                        ),
                        mainPanel(
                          plotOutput("distPlot_shiny")
                        )
                      )
             ),
             
             tabPanel("可視化", sidebarLayout(
               sidebarPanel(
                 selectInput("selected_data_for_plot", label = h3("データセットを選択してください。"),
                             choices = c("アヤメのデータ" = "iris",
                                         "不妊症の比較データ" = "infert",
                                         "ボストン近郊の不動産価格データ" = "Boston",
                                         "スパムと正常メールのデータ" = "spam",
                                         "ニューヨークの大気状態データ" = "airquality",
                                         "タイタニックの乗客データ" = "titanic"),
                             selected = "iris"),
                 selectInput("select_input_data_for_hist",
                             "ヒストグラムを表示する列番号",
                             choices = colnames(iris)),
                 sliderInput("slider_input_data",
                             "Number of bins:",
                             min = 1,
                             max = 50,
                             value = 30),
                 actionButton("trigger_histogram", "ヒストグラムを出力"),
                 
                 h3("散布図を表示する列を指定"),
                 selectInput("input_data_for_scatter_plotX",
                             "x軸",
                             choices = colnames(iris), selected = colnames(iris)[1]),
                 selectInput("input_data_for_scatter_plotY",
                             "y軸",
                             choices = colnames(iris), selected = colnames(iris)[1]),
                 actionButton("trigger_scatter_plot", "散布図を出力")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table",
                                      DT::dataTableOutput("table_for_plot")),
                             tabPanel("ヒストグラム", plotOutput("histgram")),
                             tabPanel("散布図", plotOutput("scatter_plot", brush = brushOpts(id="plot_brush")),
                                      DT::dataTableOutput("plot_brushedPoints")),
                             tabPanel("みたいに他にも図を表示する")
                 )
               )
             )),
             
             tabPanel("回帰", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("回帰結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("分類", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("分類結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("クラスタリング", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("クラスタリング結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             navbarMenu("その他",
                        tabPanel("About",
                                 h2("私の名前はNp-Urです。")),
                        tabPanel("ソースコード",
                                 a(href="https://github.com/Np-Ur/ShinyBook", 
                                   p("https://github.com/Np-Ur/ShinyBook"))
                        )
             )
  )
)

library(shiny)
library(MASS)
library(kernlab)
library(DT)
data(spam)

server <- shinyServer(function(input, output, session) {
  output$distPlot_shiny <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins_shiny + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  data_for_plot <- reactive({
    data <- switch(input$selected_data_for_plot,
                   "iris" = iris,
                   "infert" = infert,
                   "Boston" = Boston,
                   "spam" = spam,
                   "airquality" = airquality,
                   "titanic" = data.frame(lapply(data.frame(Titanic), 
                                                 function(i){rep(i, data.frame(Titanic)[, 5])}))
    )
    updateSelectInput(session, "select_input_data_for_hist", choices = colnames(data))
    updateSelectInput(session, "input_data_for_scatter_plotX", 
                      choices = colnames(data), selected = colnames(data)[1])
    updateSelectInput(session, "input_data_for_scatter_plotY", 
                      choices = colnames(data), selected = colnames(data)[1])
    
    return(data)
  })
  
  output$histgram <- renderPlot({
    input$trigger_histogram
    
    tmpData <- data_for_plot()[, isolate(input$select_input_data_for_hist)]
    x <- na.omit(tmpData)
    bins <- seq(min(x), max(x), length.out = isolate(input$slider_input_data) + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$table_for_plot <- DT::renderDataTable({
    data_for_plot()
  })
  
  
  output$scatter_plot <- renderPlot({
    input$trigger_scatter_plot
    plot(isolate(data_for_plot()[, c(input$input_data_for_scatter_plotX, 
                                     input$input_data_for_scatter_plotY)]))
  })
  
  output$plot_brushedPoints <- DT::renderDataTable({
    res <- brushedPoints(data_for_plot(), input$plot_brush, 
                         xvar = input$input_data_for_scatter_plotX,
                         yvar = input$input_data_for_scatter_plotY)
    
    if (nrow(res) == 0)
      return()
    res
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 23-googleVis / ui.R
#####################################
#install.packages("googleVis")
library(shiny)
library(googleVis)

ui <- shinyUI(fluidPage(
  titlePanel("googleVis"),
  
  sidebarLayout(
    sidebarPanel(
      h4("散布図を表示する列を指定"),
      selectInput("input_data_for_scatter_plotX",
                  "x軸",
                  choices = colnames(iris), selected = colnames(iris)[1]),
      selectInput("input_data_for_scatter_plotY",
                  "y軸",
                  choices = colnames(iris), selected = colnames(iris)[1]),
      actionButton("trigger_scatter_plot", "散布図を出力")
    ),
    mainPanel(
      htmlOutput("scatter_plot"),
      htmlOutput("line_plot"),
      htmlOutput("bar_plot"),
      htmlOutput("column_plot"),
      htmlOutput("bubble_chart")
    )
  )
))

  #インデックス番号付きのデータ生成
  iris_with_index <- iris
  iris_with_index$index <- c(1:150)
  
  #各品種の平均値を計算
  iris_summary <- data.frame(species = unique(iris$Species),
                             SepalLength = c(mean(iris$Sepal.Length[1:50]),
                                             mean(iris$Sepal.Length[51:100]),
                                             mean(iris$Sepal.Length[101:150])),
                             SepalWidth = c(mean(iris$Sepal.Width[1:50]),
                                            mean(iris$Sepal.Width[51:100]),
                                            mean(iris$Sepal.Width[101:150])))
  
  server <- shinyServer(function(input, output){
    data <- reactive({
      iris[, c(input$input_data_for_scatter_plotX, input$input_data_for_scatter_plotY)]
    })
    
    output$scatter_plot <- renderGvis({
      input$trigger_scatter_plot
      gvis$ScatterChart(isolate(data()))
    })
    
    output$line_plot <- renderGvis({
      gvisLineChart(iris_summary)
    })
    
    output$bar_plot <- renderGvis({
      gvisBarChart(iris_summary)
    })
    
    output$column_plot <- renderGvis({
      gvisColumnChart(iris_summary)
    })
    
    output$bubble_chart <- renderGvis({
      gvisBubbleChart(iris_with_index, idvar = "index", xvar = "Sepal.Length",
                      yvar = "Sepal.Width", colorvar = "Species", sizevar = "Petal.Length")
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 24-rcharts / ui.R
#####################################
#rcharts は CRANに登録された公式のライブラリーでないので、
#install方法が異なる。

require(devtools)
#source("...") #URLの指定
#install.packages("ramnathv/rCharts")

library(shiny)
library(rChatts)

ui <- shinyUI(fluidPage(
  headerPanel("rCharts"),
  
  sidebarPanel(
    selectInput(inputId = "x",
                label = "Choose X",
                choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                selected = "SepalLength"),
    selectInput(inputId = "y",
                label = "Choose Y",
                choices = c('SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'),
                selected = "SepalWidth")
  ),
  mainPanel(
    showOutput("my_chart", "nvd3")
  )
))

server <- shinyServer(function(input, output) {
  output$my_chart <- renderChart({
    names(iris) = gsub("\\.", "", names(iris))
    
    p1 <- nPlot(x = input$x, y = input$y, data = iris, type = 'scatterChart', group = "Species")
    
    p1$addParams(dom = 'my_chart')
    return(p1)
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 25-selection / ui.R
#####################################
library(shiny)
library(DT)

ui <- shinyUI(fluidPage(
  
  titlePanel("DTで行・列・セルを選択"),
  
  fluidRow(
    column(
      6, h1('行を選択'), hr(),
      DT::dataTableOutput('data1'),
      verbatimTextOutput('rows_selected')
    ),
    column(
      6, h1('列を選択'), hr(),
      DT::dataTableOutput('data2'),
      verbatimTextOutput('columns_selected')
    ),
    column(
      6, h1('セルを選択'), hr(),
      DT::dataTableOutput('data3'),
      verbatimTextOutput('cells_selected')
    )
  )
))

server <- shinyServer(function(input, output){
  
  output$data1 <- DT::renderDataTable(
    iris, selection = list(target = "row")
  )
  
  output$data2 <- DT::renderDataTable(
    iris, selection = list(target = "column")
  )
  
  output$data3 <- DT::renderDataTable(
    iris, selection = list(target = "cell")
  )
  
  output$rows_selected <- renderPrint(
    input$data1_rows_selected
  )
  
  output$columns_selected <- renderPrint(
    input$data2_columns_selected
  )
  
  output$cells_selected <- renderPrint(
    input$data3_cells_selected
  )
})

shinyApp(ui = ui, server = server)


#####################################
# 26-app-version3.0 / ui.R
#####################################

library(shiny)
library(shinythemes)
library(DT)

ui <- shinyUI(
  navbarPage("Shinyサンプルアプリケーション",
             tabPanel("Home",
                      h1("『RとShinyで作るWebアプリケーション』のサンプルアプリケーション"),
                      h2("アプリケーション概要"),
                      p("オープンソースデータを用いて可視化と分析を行えるShinyアプリです。"),
                      helpText("サンプルなので、うまく動かない可能性もあるのでご注意ください。")),
             
             tabPanel("Shinyとは?",
                      h1("Shinyでは以下のようなアプリケーションが作成できます。"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("bins_shiny",
                                      "Number of bins:",
                                      min = 1,
                                      max = 50,
                                      value = 30)
                        ),
                        mainPanel(
                          plotOutput("distPlot_shiny")
                        )
                      )
             ),
             
             tabPanel("可視化", sidebarLayout(
               sidebarPanel(
                 selectInput("selected_data_for_plot", label = h3("データセットを選択してください。"),
                             choices = c("アヤメのデータ" = "iris",
                                         "不妊症の比較データ" = "infert",
                                         "ボストン近郊の不動産価格データ" = "Boston",
                                         "スパムと正常メールのデータ" = "spam",
                                         "ニューヨークの大気状態データ" = "airquality",
                                         "タイタニックの乗客データ" = "titanic"),
                             selected = "iris"),
                 selectInput("select_input_data_for_hist",
                             "ヒストグラムを表示する列番号",
                             choices = colnames(iris)),
                 sliderInput("slider_input_data",
                             "Number of bins:",
                             min = 1,
                             max = 50,
                             value = 30),
                 actionButton("trigger_histogram", "ヒストグラムを出力"),
                 
                 h3("散布図を表示する列を指定"),
                 selectInput("input_data_for_scatter_plotX",
                             "x軸",
                             choices = colnames(iris), selected = colnames(iris)[1]),
                 selectInput("input_data_for_scatter_plotY",
                             "y軸",
                             choices = colnames(iris), selected = colnames(iris)[1]),
                 actionButton("trigger_scatter_plot", "散布図を出力")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table",
                                      DT::dataTableOutput("table_for_plot")),
                             tabPanel("ヒストグラム", plotOutput("histgram")),
                             tabPanel("散布図", plotOutput("scatter_plot", brush = brushOpts(id="plot_brush")),
                                      DT::dataTableOutput("plot_brushedPoints")),
                             tabPanel("みたいに他にも図を表示する")
                 )
               )
             )),
             
             tabPanel("回帰", sidebarLayout(
               sidebarPanel(
                 selectInput("data_for_regressionX", label = h3("データセットを選択してください。"),
                             choices = c("アヤメのデータ" = "iris",
                                         "不妊症の比較データ" = "infert",
                                         "ボストン近郊の不動産価格データ" = "Boston",
                                         "スパムと正常メールのデータ" = "spam",
                                         "ニューヨークの大気状態データ" = "airquality",
                                         "タイタニックの乗客データ" = "titanic"),
                             selected = "iris"),
                 h3("回帰を出力"),
                 selectInput("data_for_regressionY",
                             "目的変数を選択",
                             choices = colnames(iris), selected = colnames(iris)[1]),
                 h3("選択された説明変数はこちら"),
                 verbatimTextOutput("rows_selected"),
                 selectInput("regression_type",
                             "回帰の手法を選択",
                             choices = c("重回帰分析" = "lm",
                                         "ランダムフォレスト" = "rf",
                                         "3層ニューラルネット" = "nnet")),
                 actionButton("regression_button", "回帰")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table", h3("説明変数を選択してください。"), 
                                      DT::dataTableOutput("data_table_for_regression")),
                             tabPanel("回帰結果", verbatimTextOutput("summary_regression")),
                             tabPanel("プロットで結果を確認", plotOutput("plot_regression"))
                 )
               )
             )),
             
             tabPanel("分類", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("分類結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             tabPanel("クラスタリング", sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("クラスタリング結果"),
                             tabPanel("プロットで結果を確認")
                 )
               )
             )),
             
             navbarMenu("その他",
                        tabPanel("About",
                                 h2("私の名前はNp-Urです。")),
                        tabPanel("ソースコード",
                                 a(href="https://github.com/Np-Ur/ShinyBook", 
                                   p("https://github.com/Np-Ur/ShinyBook"))
                        )
             )
  )
)

library(shiny)
library(MASS)
library(kernlab)
library(DT)
data(spam)

server <- shinyServer(function(input, output, session) {
  output$distPlot_shiny <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins_shiny + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  data_for_plot <- reactive({
    data <- switch(input$selected_data_for_plot,
                   "iris" = iris,
                   "infert" = infert,
                   "Boston" = Boston,
                   "spam" = spam,
                   "airquality" = airquality,
                   "titanic" = data.frame(lapply(data.frame(Titanic), 
                                                 function(i){rep(i, data.frame(Titanic)[, 5])}))
    )
    updateSelectInput(session, "select_input_data_for_hist", choices = colnames(data))
    updateSelectInput(session, "input_data_for_scatter_plotX", 
                      choices = colnames(data), selected = colnames(data)[1])
    updateSelectInput(session, "input_data_for_scatter_plotY", 
                      choices = colnames(data), selected = colnames(data)[1])
    
    return(data)
  })
  
  output$histgram <- renderPlot({
    input$trigger_histogram
    
    tmpData <- data_for_plot()[, isolate(input$select_input_data_for_hist)]
    x <- na.omit(tmpData)
    bins <- seq(min(x), max(x), length.out = isolate(input$slider_input_data) + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$table_for_plot <- DT::renderDataTable({
    data_for_plot()
  })
  
  
  output$scatter_plot <- renderPlot({
    input$trigger_scatter_plot
    plot(isolate(data_for_plot()[, c(input$input_data_for_scatter_plotX, 
                                     input$input_data_for_scatter_plotY)]))
  })
  
  output$plot_brushedPoints <- DT::renderDataTable({
    res <- brushedPoints(data_for_plot(), input$plot_brush, 
                         xvar = input$input_data_for_scatter_plotX,
                         yvar = input$input_data_for_scatter_plotY)
    
    if (nrow(res) == 0)
      return()
    res
  })
  
  data_for_regression <- reactive({
    data <- switch(input$data_for_regressionX,
                   "iris" = iris,
                   "infert" = infert,
                   "Boston" = Boston,
                   "spam" = spam,
                   "airquality" = airquality,
                   "titanic" = data.frame(lapply(data.frame(Titanic), 
                                                 function(i){rep(i, data.frame(Titanic)[, 5])}))
    )
    updateSelectInput(session, "data_for_regressionY", choices = colnames(data), 
                      selected = colnames(data)[1])
    
    return(data)
  })
  
  output$data_table_for_regression <- DT::renderDataTable(
    t(data_for_regression()[1:10, ]), selection = list(target = 'row')
  )
  
  output$rows_selected <- renderPrint(
    input$data_table_for_regression_rows_selected
  )
  
  data_train_and_test <- reactiveValues()
  
  regression_summary <-  reactive({
    input$regression_button
    
    y <- data_for_regression()[, isolate(input$data_for_regressionY)]
    x <- data_for_regression()[, isolate(input$data_table_for_regression_rows_selected)]
    
    tmp_data <- cbind(na.omit(x), na.omit(y))
    colnames(tmp_data) <- c(colnames(x), "dependent_variable")
    train_index <- createDataPartition(tmp_data$"dependent_variable", p = .7,
                                       list = FALSE,
                                       times = 1)
    data_train_and_test$train <- tmp_data[train_index, ]
    data_train_and_test$test <- tmp_data[-train_index, ]
    
    return(train(dependent_variable ~.,
                 data = data_train_and_test$train,
                 method = isolate(input$regression_type),
                 tuneLength = 4,
                 preProcess = c('center', 'scale'),
                 trControl = trainControl(method = "cv"),
                 linout = TRUE))
  })
  
  output$summary_regression <- renderPrint({
    predict_result_residual <- predict(regression_summary(), data_train_and_test$test) - 
      data_train_and_test$test$"dependent_variable"
    cat("MSE（平均二乗誤差）")
    print(sqrt(sum(predict_result_residual ^ 2) / nrow(data_train_and_test$test)))
    summary(regression_summary())
  })
  
  output$plot_regression <- renderPlot({
    plot(predict(regression_summary(), data_train_and_test$test),
         data_train_and_test$test$"dependent_variable", 
         xlab="prediction", ylab="real")
    abline(a=0, b=1, col="red", lwd=2)
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 27-Shiny-Module-Before / ui.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  
  titlePanel("shiny-module"),
  
  fluidRow(
    column(6, 
           sliderInput("bins1",
                       "Number of bins:",
                       min = 1, max = 50, value = 30),
           plotOutput("plot1")
           ),
    column(6, 
           sliderInput("bins2",
                       "Number of bins:",
                       min = 1, max = 50, value = 30),
           plotOutput("plot2")
           )
  )
))

server <- shinyServer(function(input, output){
  
  output$plot1 <- renderPlot({
    
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = "darkgray", border = "white")
  })
  
  output$plot2 <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins2 + 1)
    hist(x, breaks = bins, col = "black", border = "white")
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 28-Shiny-Module-After / global.R
#####################################
# uiロジック部分をモジュール化
histPlotUI <- function(id, label){
  ns <- NS(id)
  
  tagList(
    sliderInput(ns("bins"),
                paste("Number of bins (",  label, "):"),
                min = 1, max = 50, value = 30),
    plotOutput(ns("plot"))
  )
}

# serverロジック部分をモジュール化
histPlot <- function(input, output, session, color){
  output$plot <- renderPlot({
    
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = color, border = 'white')
  })
}

#####################################
# 28-Shiny-Module-After / ui.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  
  titlePanel("shiny-module"),
  
  fluidRow(
    column(6, histPlotUI("bins1", "left")),
    column(6, histPlotUI("bins2", "right"))
  )
))

server <- shinyServer(function(input, output){
  callModule(histPlot, "bins1", "darkgray")
  callModule(histPlot, "bins2", "black")
})

shinyApp(ui = ui, server = server)

#####################################
# 29-app-version3.1 / global.R
#####################################
library(shiny)
library(DT)
library(caret)
library(MASS)
library(kernlab)
data(spam)

# ui modules
dataSelectUI <- function(id){
  ns <- NS(id)
  
  tagList(
    selectInput(ns("selected_data"), label = h3("データセットを選択してください。"),
                choices = c("アヤメのデータ" = "iris",
                            "不妊症の比較データ" = "infert",
                            "ボストン近郊の不動産価格データ" = "Boston",
                            "スパムと正常メールのデータ" = "spam",
                            "ニューヨークの大気状態データ" = "airquality",
                            "タイタニックの乗客データ" = "titanic"),
                selected = "iris")
  )
}

# server modules
dataSelect <- function(input, output, session, type){
  data <- switch(input$selected_data,
                 "iris" = iris,
                 "infert" = infert,
                 "Boston" = Boston,
                 "spam" = spam,
                 "airquality" = airquality,
                 "titanic" = data.frame(lapply(data.frame(Titanic), 
                                               function(i){rep(i, data.frame(Titanic)[, 5])}))
  )
  return(data)
}

# etc
get_train_and_test_data <- function(data, dependent_variable, independent_variable){
  y <- data[, dependent_variable]
  x <- data[, independent_variable]
  
  tmp_data <- cbind(x, y)
  colnames(tmp_data) <- c(colnames(x), "dependent_variable")
  
  # 学習用データと検証データに分ける
  train_index <- createDataPartition(tmp_data$"dependent_variable", 
                                     p = .7, list = FALSE, times = 1)
  data_list <- list()
  data_list <- c(data_list, list(tmp_data[train_index, ]))
  data_list <- c(data_list, list(tmp_data[-train_index, ]))
  
  return(data_list)
}

#####################################
# 29-app-version3.1 / ui.R / server.R
#####################################
library(shiny)
library(shinythemes)
library(DT)

ui <- shinyUI(
  navbarPage("Shinyサンプルアプリケーション",
             tabPanel("Home",
                      h1("『RとShinyで作るWebアプリケーション』のサンプルアプリケーション"),
                      h2("アプリケーション概要"),
                      p("オープンソースデータを用いて可視化と分析を行えるShinyアプリです。"),
                      helpText("サンプルなので、うまく動かない可能性もあるのでご注意ください。")),
             
             tabPanel("Shinyとは?",
                      h1("Shinyでは以下のようなアプリケーションが作成できます。"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("bins_shiny",
                                      "Number of bins:",
                                      min = 1,
                                      max = 50,
                                      value = 30)
                        ),
                        mainPanel(
                          plotOutput("distPlot_shiny")
                        )
                      )
             ),
             
             tabPanel("可視化", sidebarLayout(
               sidebarPanel(
                 dataSelectUI("plot"),
                 selectInput("select_input_data_for_hist",
                             "ヒストグラムを表示する列番号",
                             choices = colnames(iris)),
                 sliderInput("slider_input_data",
                             "Number of bins:",
                             min = 1,
                             max = 50,
                             value = 30),
                 actionButton("trigger_histogram", "ヒストグラムを出力"),
                 
                 h3("散布図を表示する列を指定"),
                 selectInput("input_data_for_scatter_plotX",
                             "x軸",
                             choices = colnames(iris), selected = colnames(iris)[1]),
                 selectInput("input_data_for_scatter_plotY",
                             "y軸",
                             choices = colnames(iris), selected = colnames(iris)[1]),
                 actionButton("trigger_scatter_plot", "散布図を出力")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table",
                                      DT::dataTableOutput("table_for_plot")),
                             tabPanel("ヒストグラム", plotOutput("histgram")),
                             tabPanel("散布図", plotOutput("scatter_plot", brush = brushOpts(id="plot_brush")),
                                      DT::dataTableOutput("plot_brushedPoints")),
                             tabPanel("みたいに他にも図を表示する")
                 )
               )
             )),
             
             tabPanel("回帰", sidebarLayout(
               sidebarPanel(
                 dataSelectUI("regression"),
                 h3("回帰を出力"),
                 selectInput("data_for_regressionY",
                             "目的変数を選択",
                             choices = colnames(iris), selected = colnames(iris)[1]),
                 h3("選択された説明変数はこちら"),
                 verbatimTextOutput("rows_selected"),
                 selectInput("regression_type",
                             "回帰の手法を選択",
                             choices = c("重回帰分析" = "lm",
                                         "ランダムフォレスト" = "rf",
                                         "3層ニューラルネット" = "nnet")),
                 actionButton("regression_button", "回帰")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table", h3("説明変数を選択してください。"),
                                      DT::dataTableOutput("data_table_for_regression")),
                             tabPanel("回帰結果", verbatimTextOutput("summary_regression")),
                             tabPanel("プロットで結果を確認", plotOutput("plot_regression"))
                 )
               )
             )),
             
             tabPanel("分類", sidebarLayout(
               sidebarPanel(
                 dataSelectUI("classification"),
                 h3("分類を出力"),
                 selectInput("data_for_classificationY",
                             "目的変数を選択",
                             choices = colnames(iris), selected = colnames(iris)[1]),
                 h3("選択された説明変数はこちら"),
                 verbatimTextOutput("rows_selected_classification"),
                 selectInput("classification_type",
                             "分類の手法を選択",
                             choices = c("ランダムフォレスト" = "rf",
                                         "3層ニューラルネット" = "nnet")),
                 actionButton("classification_button", "分類")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table", h3("説明変数を選択してください。"), 
                                      DT::dataTableOutput("data_table_for_classification")),
                             tabPanel("分類結果", verbatimTextOutput("summary_classification"))
                 )
               )
             )),
             
             tabPanel("クラスタリング", sidebarLayout(
               sidebarPanel(
                 dataSelectUI("clustering"),
                 h3("選択された変数はこちら"),
                 verbatimTextOutput("rows_selected_clustering"),
                 numericInput("cluster_number", "クラスタ数を指定",
                              min = 1, max = 5, value = 1),
                 actionButton("clustering_button", "クラスタリング")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Table", h3("説明変数を選択してください。"),
                                      DT::dataTableOutput("data_table_for_clustering")),
                             tabPanel("クラスタリング結果", 
                                      h3("左端にクラスタ番号が入っています。"),
                                      DT::dataTableOutput("data_with_clustering_result"))
                 )
               )
             )),
             
             navbarMenu("その他",
                        tabPanel("About",
                                 h2("私の名前はNp-Urです。")),
                        tabPanel("ソースコード",
                                 a(href="https://github.com/Np-Ur/ShinyBook", 
                                   p("https://github.com/Np-Ur/ShinyBook"))
                        )
             )
  )
)

library(shiny)
library(MASS)
library(kernlab)
library(DT)
data(spam)

server <- shinyServer(function(input, output, session) {
  output$distPlot_shiny <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins_shiny + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  data_for_plot <- reactive({
    data <- callModule(dataSelect, "plot")
    
    updateSelectInput(session, "select_input_data_for_hist", choices = colnames(data))
    updateSelectInput(session, "input_data_for_scatter_plotX", 
                      choices = colnames(data), selected = colnames(data)[1])
    updateSelectInput(session, "input_data_for_scatter_plotY", 
                      choices = colnames(data), selected = colnames(data)[1])
    
    return(data)
  })
  
  output$histgram <- renderPlot({
    input$trigger_histogram
    
    tmpData <- data_for_plot()[, isolate(input$select_input_data_for_hist)]
    x <- na.omit(tmpData)
    bins <- seq(min(x), max(x), length.out = isolate(input$slider_input_data) + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$table_for_plot <- DT::renderDataTable({
    data_for_plot()
  })
  
  
  output$scatter_plot <- renderPlot({
    input$trigger_scatter_plot
    plot(isolate(data_for_plot()[, c(input$input_data_for_scatter_plotX, 
                                     input$input_data_for_scatter_plotY)]))
  })
  
  output$plot_brushedPoints <- DT::renderDataTable({
    res <- brushedPoints(data_for_plot(), input$plot_brush, 
                         xvar = input$input_data_for_scatter_plotX,
                         yvar = input$input_data_for_scatter_plotY)
    
    if (nrow(res) == 0)
      return()
    res
  })
  
  # -------------------------
  # regressionに関する処理
  # -------------------------
  
  data_for_regression <- reactive({
    data <- callModule(dataSelect, "regression")
    updateSelectInput(session, "data_for_regressionY", choices = colnames(data), 
                      selected = colnames(data)[1])
    
    return(na.omit(data))
  })
  
  output$data_table_for_regression <- DT::renderDataTable(
    t(data_for_regression()[1:10, ]), selection = list(target = 'row')
  )
  
  output$rows_selected <- renderPrint(
    input$data_table_for_regression_rows_selected
  )
  
  data_train_and_test <- reactiveValues()
  
  regression_summary <-  reactive({
    input$regression_button
    
    tmp_data_list <- get_train_and_test_data(data_for_regression(),
                                             isolate(input$data_for_regressionY),
                                             isolate(input$data_table_for_regression_rows_selected))
    
    data_train_and_test$train <- tmp_data_list[[1]]
    data_train_and_test$test <- tmp_data_list[[2]]
    
    return(train(dependent_variable ~.,
                 data = data_train_and_test$train,
                 method = isolate(input$regression_type),
                 tuneLength = 4,
                 preProcess = c('center', 'scale'),
                 trControl = trainControl(method = "cv"),
                 linout = TRUE))
  })
  
  output$summary_regression <- renderPrint({
    predict_result_residual <- predict(regression_summary(), data_train_and_test$test) - 
      data_train_and_test$test$"dependent_variable"
    cat("MSE（平均二乗誤差）")
    print(sqrt(sum(predict_result_residual ^ 2) / nrow(data_train_and_test$test)))
    summary(regression_summary())
  })
  
  output$plot_regression <- renderPlot({
    plot(predict(regression_summary(), data_train_and_test$test),
         data_train_and_test$test$"dependent_variable", 
         xlab="prediction", ylab="real")
    abline(a=0, b=1, col="red", lwd=2)
  })
  
  # -------------------------
  # classificationに関する処理
  # -------------------------
  
  data_for_classification <- reactive({
    data <- callModule(dataSelect, "classification")
    updateSelectInput(session, "data_for_classificationY", 
                      choices = colnames(data), selected = colnames(data)[1])
    return(na.omit(data))
  })
  
  output$data_table_for_classification <- DT::renderDataTable(
    t(data_for_classification()[1:10, ]), selection = list(target = 'row')
  )
  
  output$rows_selected_classification <- renderPrint(
    input$data_table_for_classification_rows_selected
  )
  
  data_train_and_test_classification <- reactiveValues()
  
  classification_summary <-  reactive({
    input$classification_button
    
    tmp_data_list <- get_train_and_test_data(data_for_classification(),
                                             isolate(input$data_for_classificationY),
                                             isolate(input$data_table_for_classification_rows_selected))
    data_train_and_test_classification$train <- tmp_data_list[[1]]
    data_train_and_test_classification$test <- tmp_data_list[[2]]
    
    return(train(dependent_variable ~.,
                 data = data_train_and_test_classification$train,
                 method = isolate(input$classification_type),
                 tuneLength = 4,
                 preProcess = c('center', 'scale'),
                 trControl = trainControl(method = "cv"),
                 linout = FALSE))
  })
  
  output$summary_classification <- renderPrint({
    cat("サマリー）")
    print(confusionMatrix(data = predict(classification_summary(), 
                                         data_train_and_test_classification$test),
                          data_train_and_test_classification$test$"dependent_variable"))
    summary(classification_summary())
  })
  
  # -------------------------
  # clusteringに関する処理
  # -------------------------
  
  data_for_clustering <- reactive({
    data <- callModule(dataSelect, "clustering")
    return(na.omit(data))
  })
  
  output$data_table_for_clustering <- DT::renderDataTable(
    t(data_for_clustering()[1:10, ]), selection = list(target = 'row')
  )
  
  output$rows_selected_clustering <- renderPrint(
    input$data_table_for_clustering_rows_selected
  )
  
  clustering_summary <-  reactive({
    input$clustering_button
    
    clusters <- kmeans(isolate(data_for_clustering()[, 
                                                     input$data_table_for_clustering_rows_selected]),
                       centers = isolate(input$cluster_number))
    return(clusters$cluster)
  })
  
  output$data_with_clustering_result <- DT::renderDataTable({
    cbind(clustering_summary(), data_for_clustering())
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 30-fileInput / ui.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "CSVファイルをアップロード",
                accept = c("text/csv", "text/comma-separated-values, text/plain",".csv")
                )
    ),
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Table", tableOutput("table"))
                  )
    )
  )
))

server <- shinyServer(function(input, output){
  observeEvent(input$file,{
    csv_file <- reactive(read.csv(input$file$datapath))
    output$table <- renderTable(csv_file())
  })
})

shinyApp(ui = ui, server = server)

#####################################
# 31-download / ui.R
#####################################
library(shiny)

ui <- shinyUI(fluidPage(
  
  titlePanel("download"),
  
  fluidRow(
    column(6, plotOutput("plot", brush = brushOpts(id = "brush")),
           downloadButton("download_data", "Download")),
    column(6, DT::dataTableOutput("brushed_point"))
  )
))

server <- shinyServer(function(input, output){
  output$plot <- renderPlot({
    plot(iris[, c(1, 2)])
  })
  
  data_brushed <- reactive({
    return(brushedPoints(iris, input$brush, xvar = "Sepal.Length", yvar = "Sepal.Width"))
  })
  
  output$brushed_point <- DT::renderDataTable({
    data_brushed()
  })
  
  output$download_data = downloadHandler(
    filename = "iris_brushed.csv",
    content = function(file){
      write.csv(data_brushed(), file)
    }
  )
})

shinyApp(ui = ui, server = server)


###################################################
# chapter04 地図と連携させた Shiny アプリケーション
###################################################

###################################
#01-app-version 1.0 / ui.R
###################################
#("shinydashboard", dependencies = TRUE)
library("shinydashboard")

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output){}

shinyApp(ui = ui, server = server)

##################################
# 02-shinydashboard / ui.R
##################################
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Sample"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("tabA", tabName = "tab_A"),
      menuItem("tabB", tabName = "tab_B")
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab_A",
              titlePanel("tab_Aの中身"),
              sidebarLayout(
                sidebarPanel(
                  sliderInput("bins", 
                              "Number of bins:",
                              min = 1, max = 50, value = 30)
                ),
                mainPanel(
                  plotOutput("distPlot")
                )
              )),
      tabItem(tabName = "tab_B",
              titlePanel("tab_Bの中身"))
    )
  )
)

server <- shinyServer(function(input, output){
  output$distPlot <- renderPlot({
    
    #uiから受け取ったbins情報をもとに階級幅を生成
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    #ヒストグラムの生成
    hist(x, breaks = bins, col = "darkgray", border = "white")
  })
})



shinyApp(ui = ui, server = server)

####################################
#03-app-version 1.1 / ui.R
####################################

library(shiny)
library(shinydashboard)

ui <- dashboardPage(
#headerの設定
header <- dashboardHeader(title = "地図アプリ"),
  
#sidebarの設定
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard",
             tabName = "tab_dashboard", icon = icon("dashboard")),
    menuItem("leafletの基本機能", icon = icon("th"),
             tabName = "leaflet_basic",
             menuSubItem("Basic", tabName = "tab_basic", icon = icon("envira")),
             menuSubItem("Distance App", tabName = "tab_distance",
                         icon = icon("map-marker"))),
    menuItem("Prefectures", icon = icon("th"), tabName = "prefectures",
             menuSubItem("Table"), tabName = "tab_table", icon = icon("table")),
    menuItem("Product", "tab_product", icon = icon("search")),
    menuSubItem("Clustering", tabName = "tab_clustering", icon = icon("line-chart"))
  )
),

#bodyの設定
body <- dashboardBody(
  tabItems(
    tabItem("tab_dashboard", titlePanel("Shinyで作成した地図アプリです。"),
            h3("shinydashboardライブラリを使用しています。")),
    tabItem("tab_basic"),
    tabItem("tab_table"),
    tabItem("tab_product"),
    tabItem("tab_clustering")
  )
),

dashboardPage(
  header,
  sidebar,
  body
  )

)

server <- function(input, output){}

shinyApp(ui = ui, server = server)

##############################
# 03-app-version1.1 / ui.R
##############################

library(shiny)
library(shinydashboard)

ui <- dashboardPage(

#headerの設定
header <- dashboardHeader(title = "地図アプリ"),

#sidebarの設定
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard",
             tabName = "tab_dashboard", iicon = icon("dashboard")),
    menuItem("leafletの基本機能", icon = icon("th"),
             tabName = "leaflet_basic",
             menuSubItem("Basic", tabName = "tab_basic", icon = icon("envira")),
             menuSubItem("Distance App", tabName = "tab_distance",
                         icon = icon("map_maker"))),
    menuItem("Prefectures", icon = icon("th"), tabName = "prefectures",
             menuSubItem("Table", "tab-product", icon = icon("search")),
             menuSubItem("Product", "tab_product", icon = icon("search")),
             menuSubItem("Clustering", tabName = "tab_clustering", icon = icon("line-chart"))
             )
  )
),

#bodyの設定
body <- dashboardBody(
  tabItem(
    tabItem("tab_dashboard", titlePanel("Shinyで作成した地図アプリです。"),
            h3("shinydashboardライブラリを使用しています。")),
    tabItem("tab_basic"),
    tabItem("tab_distance"),
    tabItem("tab_table"),
    tabItem("tab_clustering")
  )
),

dashboardPage(
  header,
  sidebar,
  body
)

)

server <- function(input, output){}

shinyApp(ui = ui, server = server)


###############################
# SECTION 25 leaflet ライブラリ
###############################

#leafletライブラリのインストール
#install.packages("leaflet")
library("leaflet")
leaflet() %>% addTiles()

leaflet() %>%
  addTiles() %>%
  addMarkers(lng = 139.7, lat = 35.7)

leaflet() %>% 
  addTiles() %>%
  addMarkers(lng = 139.7, lat = 35.7) %>%
  addCircles(lng = 139, lat = 35, radius = 5000, weight = 1)

leaflet() %>%
  addTiles() %>%
  addMarkers(lng = 139.7, lat = 35.7) %>%
  addCircles(lng = 139, lat = 35, radius = 5000) %>%
  addMeasure(position = "topright", primaryLengthUnit = "meters",
             primaryAreaUnit = "sqmeters", activeColor = "#ABE67E",
             completedColor = "#2f4f4f")

leaflet(map) %>% addTiles() %>%
  setView(lat = 39, lng = 139, zoom = 7)

data <- data.frame(
  lng = c(135.1, 135.2, 135.3, 135.4, 135.5),
  lat = c(35.1, 35.2, 35.3, 35.4, 35.5)
)

leaflet(data) %>% addTiles() %>% addMarkers(lng =~ lng, lat =~ lat)

#Shinyアプリケーションへの組み込み
#install.packages("ggmap", dependencies = TRUE)
library(shiny)
library(shinydashboard)
library(ggmap)
library(leaflet)

###############################
# 04-app-version2.0 / global.R
###############################
#Shinyアプリケーションへの組み込み
#install.packages("ggmap", dependencies = TRUE)
library(shiny)
library(shinydashboard)
library(ggmap)
library(leaflet)

#headerの設定
header <- dashboardHeader(title = "地図アプリ")

#sidebarの設定
ui <- dashboardPage(
  # headerの設定
  header <- dashboardHeader(title = "地図アプリ"),
  
  # sidebarの設定
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard",
               tabName = "tab_dashboard", icon = icon("dashboard")),
      menuItem("leafletの基本機能", icon = icon("th"),
               tabName = "leaflet_basic",
               menuSubItem("Basic", tabName = "tab_basic", icon = icon("envira")),
               menuSubItem("Distance App", tabName = "tab_distance", 
                           icon = icon("map-marker"))),
      menuItem("Prefectures", icon = icon("th"), tabName = "prefectures",
               menuSubItem("Table", tabName = "tab_table", icon = icon("table")),
               menuSubItem("Product", "tab_product", icon = icon("search")),
               menuSubItem("Clustering", tabName = "tab_clustering", icon = icon("line-chart"))
      )
    )
  ),
  
  # bodyの設定
  body <- dashboardBody(
    tabItems(
      tabItem("tab_dashboard", titlePanel("Shiny で作成した地図アプリです。"),
              h3("shinydashboardライブラリを使用しています。")),
      tabItem("tab_basic",
              box(leaflet() %>%
                    addTiles() %>%
                    addMarkers(lng = 139.7, lat = 35.7)),
              box(leaflet() %>%
                    addTiles() %>%
                    addMarkers(lng = 139.7, lat = 35.7) %>%
                    addCircles(lng = 139, lat = 35, radius = 5000))),
      tabItem("tab_distance",
              titlePanel("距離を図る"),
              sidebarLayout(
                sidebarPanel(
                  textInput("search_word1", "ワード1", value="東京"),
                  textInput("search_word2", "ワード2", value="千葉"),
                  
                  h4("実行に数秒時間がかかります。"),
                  h4("APIがエラーを返す場合があるので、その際は時間を置いてお試しください。"),
                  actionButton("submit_dist", "地図を描写")
                ),
                mainPanel(
                  leafletOutput("plot_dist", width="100%", height = "900px")
                )
              )
      ),
      tabItem("tab_table"),
      tabItem("tab_product"),
      tabItem("tab_clustering")
    )
  ),
  
  dashboardPage(
    header,
    sidebar,
    body
  )
)

########################################
# 04-app-version2.0 / server.R
########################################

server <- function(input, output) {
  values <- reactiveValues(geocodes = rbind(c(139.6917, 35.68949),
                                            c(140.1233, 35.60506)))
  
  observeEvent(input$submit_dist, {
    geo1 <- geocode(input$search_word1)
    geo2 <- geocode(input$search_word2)
    
    # modalダイアログの表示
    if (is.na(geo1[1, 1]) || is.na(geo2[1, 1])) {
      showModal(modalDialog(title = "エラー", "検索条件に該当するデータがありません",
                            easyClose = TRUE, footer = modalButton("OK")))
    }
    # geo1 geo2どちらかがnullであれば、これ以降の動作を止める
    req(geo1[1, 1])
    req(geo2[1, 1])
    
    values$geocodes <- rbind(geo1, geo2)
  })
  
  output$plot_dist <- renderLeaflet({
    geo1_lng <- values$geocodes[1, 1]
    geo1_lat <- values$geocodes[1, 2]
    geo2_lng <- values$geocodes[2, 1]
    geo2_lat <- values$geocodes[2, 2]
    
    leaflet() %>% addTiles() %>%
      setView(lng = (geo1_lng + geo2_lng)/2, lat = (geo1_lat + geo2_lat)/2, zoom = 5) %>%
      addMarkers(lng = geo1_lng, lat = geo1_lat, label = input$search_word1) %>%
      addMarkers(lng = geo2_lng, lat = geo2_lat, label = input$search_word2) %>%
      addMeasure(position = "topright", primaryLengthUnit = "meters")
  })
}

shinyApp(ui = ui, server = server)


######################################
# SECTION-026 都道府県データの読み込み
######################################
#install.packages("rgdal", dependencies = TRUE)
#install.packages("maptools", dependencies = TRUE)
#install.packages("dplyr", dependencies = TRUE)
#install.packages("rmapshaper", dependencies = TRUE)

library(rgdal)
library(maptools)
library(dplyr)
library(rmapshaper)

setwd("C:/Users/rymnk/Documents/shiny_learning/")
map <- readOGR(dsn = "./N03-140401_GML/",
               layer = "N03-14-140401", encoding = "shift-JIS",
               stringsAsFactors = FALSE)

#シェープファイルの読み込み
shape <- readOGR("./N03-140401_GML/", layer = "N03-14-140401",
                 encoding = "shift-JIS", stringsAsFactors = FALSE)

#データフレーム作成(都道府県とidの列だけ)
shape_df <- as(shape, "data.frame")
shape_df_pref <- shape_df %>%
  group_by(N03-001) %>%
  summarise()
shape_df_pref$pref_id <- row.names(shape_df_pref)

#polygonの結合
shape_merged <- merge(shape, shape_df_pref)
shape_union <- unionSpatialPolygons(shape_merged, shape_merged@data$pref_id)

#spatialdataframeに直す
regions_unions <- sp::SpatialPolygonsDataFrame(shape_union, shape_df_pref)


#install.packages("shinydashboard", dependencies = TRUE)
#install.packages("rgdal", dependencies = TRUE)
#install.packages("maptools", dependencies = TRUE)
#install.packages("dplyr", dependencies = TRUE)
#install.packages("rmapshaper", dependencies = TRUE)
#install.packages("leaflet", dependencies = TRUE)

library("shiny")
library("shinydashboard")
library("rgdal")
library("maptools")
library("dplyr")
library("rmapshaper")
library("leaflet")

ui <- shinyUI(fluidPage(
  
  titlePanel("absolutePanelの例"),
  
  sidebarLayout(
    plotOutput("distPlot"),
    absolutePanel(draggable = TRUE, top = 60, left = "auto",
                  right = 20, bottom = "auto", width = 350, 
                  height = "auto",
                  h2("absolutePanel"), sliderInput("bins", "Number of bins:",
                                                   min = 1, max = 50, value = 30)
    )
  )
  
))

server<- shinyServer(function(input, output){
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = "darkgray", border = "white")
  })
})

shinyApp(ui = ui, server = server)


###############################
# 07-app-version3.1 / global.R
###############################
library(shiny)
library(shinydashboard)
library(ggmap)
library(leaflet)
library(rgdal)

map <- readOGR(dsn = "./data", layer = "sample", encoding = "UTF-8",
               stringsAsFactors = FALSE)

attribute_data <- read.csv("./data/attribute.csv")

#windowsユーザーで、上手く読み込めない場合はこちら
#library(readr)
#attribute <- read.csv("./data/attribute.csv)
#attribute_data <- as.data.frame(attribute)

#以下追加箇所
#selectInputで使う選択肢を読み込み
colors <- c("BrBG", "BuPu", "Oranges")
categories <- c("野菜"　= "vegetables",
                "果物" = "fruit", "人口" = "population")
plot_choices <- c("circle", "polygons")
vegetables_choices <- c(トマト = "トマト", なす = "なす",
                           はくさい = "はくさい")
fruit_choices <- c(りんご = "りんご", ぶどう = "ぶどう")
population_choices <- c(人口 = "population", 人口密度 = "pop_density")

##########################
# 07-app-version3.1 / ui.R
##########################
ui <- shinyUI(dashboardPage(
  
  # headerの設定
  header <- dashboardHeader(title = "地図アプリ"),
  
  # sidebarの設定
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard",
               tabName = "tab_dashboard", icon = icon("dashboard")),
      menuItem("leafletの基本機能", icon = icon("th"),
               tabName = "leaflet_basic",
               menuSubItem("Basic", tabName = "tab_basic", icon = icon("envira")),
               menuSubItem("Distance App", tabName = "tab_distance", icon = icon("map-marker"))),
      menuItem("Prefectures", icon = icon("th"), tabName = "prefectures",
               menuSubItem("Table", tabName = "tab_table", icon = icon("table")),
               menuSubItem("Product", "tab_product", icon = icon("search")),
               menuSubItem("Clustering", tabName = "tab_clustering", icon = icon("line-chart"))
      )
    )
  ),
  
  # bodyの設定
  body <- dashboardBody(
    tabItems(
      tabItem("tab_dashboard", titlePanel("Shiny で作成した地図アプリです。"),
              h3("shinydashboardライブラリを使用しています。")),
      tabItem("tab_basic",
              box(leaflet() %>%
                    addTiles() %>%
                    addMarkers(lng = 139.7, lat = 35.7)),
              box(leaflet() %>%
                    addTiles() %>%
                    addMarkers(lng = 139.7, lat = 35.7) %>%
                    addCircles(lng = 139, lat = 35, radius = 5000))),
      tabItem("tab_distance",
              titlePanel("距離を図る"),
              sidebarLayout(
                sidebarPanel(
                  textInput("search_word1", "ワード1", value="東京"),
                  textInput("search_word2", "ワード2", value="千葉"),
                  
                  h4("実行に数秒時間がかかります。"),
                  h4("APIがエラーを返す場合があるので、その際は時間を置いてお試しください。"),
                  actionButton("submit_dist", "地図を描写")
                ),
                mainPanel(
                  leafletOutput("plot_dist", width="100%", height = "900px")
                )
              )
      ),
      tabItem("tab_table",
              DT::dataTableOutput("attribute_table")),
      # 以下追加箇所
      tabItem("tab_product",
              fluidRow(
                tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                box(width = 12, collapsible = TRUE,
                    leafletOutput("plot_product", height = 700)
                ),
                absolutePanel(id = "absolute-panel",
                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                              width = 350, height = "auto",
                              
                              h2("menu"),
                              
                              selectInput("category", "カテゴリー", choices = categories),
                              hr(),
                              uiOutput("choices_for_plot"),
                              selectInput("plot_type", "Plot Choice", choices = plot_choices),
                              uiOutput("circle_size_ui"),
                              selectInput("color", "Color Scheme", choices = colors)
                )
              )
      ),
      tabItem("tab_clustering")
    )
  ),
  
  dashboardPage(
    header,
    sidebar,
    body
  )
  
))

##############################
# 07-app-version3.1 / server.R
##############################
server <- function(input, output) {
  values <- reactiveValues(geocodes = rbind(c(139.6917, 35.68949),
                                            c(140.1233, 35.60506)))
  
  observeEvent(input$submit_dist, {
    geo1 <- geocode(input$search_word1)
    geo2 <- geocode(input$search_word2)
    
    # modalダイアログの表示
    if (is.na(geo1[1, 1]) || is.na(geo2[1, 1])) {
      showModal(modalDialog(title = "エラー",
                            "検索条件に該当するデータがありません",
                            easyClose = TRUE, footer = modalButton("OK")))
    }
    # geo1 geo2どちらかがnullであれば、これ以降の動作を止める
    req(geo1[1, 1])
    req(geo2[1, 1])
    
    values$geocodes <- rbind(geo1, geo2)
  })
  
  output$plot_dist <- renderLeaflet({
    geo1_lng <- values$geocodes[1, 1]
    geo1_lat <- values$geocodes[1, 2]
    geo2_lng <- values$geocodes[2, 1]
    geo2_lat <- values$geocodes[2, 2]
    
    leaflet() %>% addTiles() %>%
      setView(lng = (geo1_lng + geo2_lng)/2,
              lat = (geo1_lat + geo2_lat)/2, zoom = 5) %>%
      addMarkers(lng = geo1_lng, lat = geo1_lat,
                 label = input$search_word1) %>%
      addMarkers(lng = geo2_lng, lat = geo2_lat,
                 label = input$search_word2) %>%
      addMeasure(position = "topright", primaryLengthUnit = "meters")
  })
  
  output$attribute_table <- DT::renderDataTable({
    attribute_data
  })
  
  # 以下追加箇所
  output$choices_for_plot <- renderUI({
    if (is.null(input$category))
      return()
    
    switch(input$category,
           "vegetables" = radioButtons("dynamic", "野菜生産量",
                                       choices = vegetables_choices),
           "fruit" = radioButtons("dynamic", "果物生産量",
                                  choices = fruit_choices),
           "population" = radioButtons("dynamic", "人口",
                                       choices = population_choices)
    )
  })
  
  output$circle_size_ui <- renderUI({
    if (input$plot_type == "circle"){
      sliderInput("size_slider", "Circle Size", min = 1,
                  max = 100000, value = 1000)
    }
  })
  
  output$plot_product <- renderLeaflet({
    selected_attribute <- attribute_data[, input$dynamic]
    pal <- colorNumeric(input$color, domain = selected_attribute)
    
    if (input$plot_type == "circle") {
      leaflet(attribute_data) %>% addTiles() %>%
        setView(lat = 39, lng = 139, zoom = 5) %>%
        addCircles(lng = ~lon, lat = ~lat,
                   radius = sqrt(as.numeric(selected_attribute) * input$size_slider),
                   fillOpacity = 0.5, weight = 1,
                   color = "#777777", fillColor = pal(selected_attribute),
                   popup = ~paste(prefecture, selected_attribute, sep = ": "))
    } else {
      leaflet(map) %>% addTiles() %>%
        setView(lat = 39, lng = 139, zoom = 5) %>%
        addPolygons(fillOpacity = 0.5, weight = 1,
                    fillColor = pal(selected_attribute),
                    popup = ~paste(prefecture)) %>%
        addLegend("bottomright", pal = pal,
                  values = selected_attribute, title = input$dynamic)
    }
  })
}

shinyApp(ui = ui, server = server)

###########################
# 08-app-version3.2 / ui.R
###########################

#統計情報をもとにクラスタリングを行って可視化する。
ui <- dashboardPage(
  
  # headerの設定
  header <- dashboardHeader(title = "地図アプリ"),
  
  # sidebarの設定
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard",
               tabName = "tab_dashboard", icon = icon("dashboard")),
      menuItem("leafletの基本機能", icon = icon("th"),
               tabName = "leaflet_basic",
               menuSubItem("Basic", tabName = "tab_basic", icon = icon("envira")),
               menuSubItem("Distance App", tabName = "tab_distance", icon = icon("map-marker"))),
      menuItem("Prefectures", icon = icon("th"), tabName = "prefectures",
               menuSubItem("Table", tabName = "tab_table", icon = icon("table")),
               menuSubItem("Product", "tab_product", icon = icon("search")),
               menuSubItem("Clustering", tabName = "tab_clustering", icon = icon("line-chart"))
      )
    )
  ),
  
  # bodyの設定
  body <- dashboardBody(
    tabItems(
      tabItem("tab_dashboard", titlePanel("Shiny で作成した地図アプリです。"),
              h3("shinydashboardライブラリを使用しています。")),
      tabItem("tab_basic",
              box(leaflet() %>%
                    addTiles() %>%
                    addMarkers(lng = 139.7, lat = 35.7)),
              box(leaflet() %>%
                    addTiles() %>%
                    addMarkers(lng = 139.7, lat = 35.7) %>%
                    addCircles(lng = 139, lat = 35, radius = 5000))),
      tabItem("tab_distance",
              titlePanel("距離を図る"),
              sidebarLayout(
                sidebarPanel(
                  textInput("search_word1", "ワード1", value="東京"),
                  textInput("search_word2", "ワード2", value="千葉"),
                  
                  h4("実行に数秒時間がかかります。"),
                  h4("APIがエラーを返す場合があるので、その際は時間を置いてお試しください。"),
                  actionButton("submit_dist", "地図を描写")
                ),
                mainPanel(
                  leafletOutput("plot_dist", width="100%", height = "900px")
                )
              )
      ),
      tabItem("tab_table",
              DT::dataTableOutput("attribute_table")),
      tabItem("tab_product",
              fluidRow(
                tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                box(width = 12, collapsible = TRUE,
                    leafletOutput("plot_product", height = 700)
                ),
                absolutePanel(id = "absolute-panel",
                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                              width = 350, height = "auto",
                              
                              h2("menu"),
                              
                              selectInput("category", "カテゴリー", choices = categories),
                              hr(),
                              uiOutput("choices_for_plot"),
                              selectInput("plot_type", "Plot Choice", choices = plot_choices),
                              uiOutput("circle_size_ui"),
                              selectInput("color", "Color Scheme", choices = colors)
                )
              )
      ),
      #以下変更箇所
      tabItem("tab_clustering",
              fluidRow(
                box(width = 3, background = 'blue',
                    h2("都道府県をクラスタリング"),
                    hr(),
                    
                    selectInput("data_for_clustering", h3("クラスタリングに用いるデータ列を選択"),
                                colnames(attribute_data)[2:ncol(attribute_data)],
                                multiple = TRUE, selected = colnames(attribute_data)[2:4]),
                    selectInput("clustering_method", "クラスタリングの種類",
                                c("階層的（complete）" = "hclust", "非階層的（k-means）" = "k-means")),
                    numericInput("number_of_cluster", "何個のクラスターに分類？", 1,
                                 min = 1, max = 10),
                    actionButton("get_clustering", "クラスタリング実行"),
                    
                    h3("散布図プロットするデータを選択"),
                    selectInput("plot_x", "x軸方向", colnames(attribute_data)[2:ncol(attribute_data)]),
                    selectInput("plot_y", "x軸方向", colnames(attribute_data)[2:ncol(attribute_data)]),
                    
                    actionButton("get_plot", "プロット")
                ),
                tabBox(width = 9,
                       tabPanel("table", tableOutput('table_with_cluster')),
                       tabPanel("Plot",
                                plotOutput("plot_with_cluster", brush = "plot_brush"),
                                verbatimTextOutput("info")
                       ),
                       tabPanel("mapping", leafletOutput("map_with_cluster"))
                )
              )
      )
    )
  ),
  
  dashboardPage(
    header,
    sidebar,
    body
  )
  
)

##############################
# 08-app-version3.2 / server.R
##############################

server <- shinyServer(function(input, output){
  values <- reactiveValues(geocodes = rbind(c(139.6917, 35.68949),
                                            c(140.1233, 35.60506)))
  
  observeEvent(input$submit_dist, {
    geo1 <- geocode(input$search_word1)
    geo2 <- geocode(input$search_word2)
    
    # modalダイアログの表示
    if (is.na(geo1[1, 1]) || is.na(geo2[1, 1])) {
      showModal(modalDialog(title = "エラー",
                            "検索条件に該当するデータがありません",
                            easyClose = TRUE, footer = modalButton("OK")))
    }
    # geo1 geo2どちらかがnullであれば、これ以降の動作を止める
    req(geo1[1, 1])
    req(geo2[1, 1])
    
    values$geocodes <- rbind(geo1, geo2)
  })
  
  output$plot_dist <- renderLeaflet({
    geo1_lng <- values$geocodes[1, 1]
    geo1_lat <- values$geocodes[1, 2]
    geo2_lng <- values$geocodes[2, 1]
    geo2_lat <- values$geocodes[2, 2]
    
    leaflet() %>% addTiles() %>%
      setView(lng = (geo1_lng + geo2_lng)/2,
              lat = (geo1_lat + geo2_lat)/2, zoom = 5) %>%
      addMarkers(lng = geo1_lng, lat = geo1_lat,
                 label = input$search_word1) %>%
      addMarkers(lng = geo2_lng, lat = geo2_lat,
                 label = input$search_word2) %>%
      addMeasure(position = "topright", primaryLengthUnit = "meters")
  })
  
  output$attribute_table <- DT::renderDataTable({
    attribute_data
  })
  
  # 以下追加箇所
  output$choices_for_plot <- renderUI({
    if (is.null(input$category))
      return()
    
    switch(input$category,
           "vegetables" = radioButtons("dynamic", "野菜生産量",
                                       choices = vegetables_choices),
           "fruit" = radioButtons("dynamic", "果物生産量",
                                  choices = fruit_choices),
           "population" = radioButtons("dynamic", "人口",
                                       choices = population_choices)
    )
  })
  
  output$circle_size_ui <- renderUI({
    if (input$plot_type == "circle"){
      sliderInput("size_slider", "Circle Size", min = 1,
                  max = 100000, value = 1000)
    }
  })
  
  output$plot_product <- renderLeaflet({
    selected_attribute <- attribute_data[, input$dynamic]
    pal <- colorNumeric(input$color, domain = selected_attribute)
    
    if (input$plot_type == "circle") {
      leaflet(attribute_data) %>% addTiles() %>%
        setView(lat = 39, lng = 139, zoom = 5) %>%
        addCircles(lng = ~lon, lat = ~lat,
                   radius = sqrt(as.numeric(selected_attribute) * input$size_slider),
                   fillOpacity = 0.5, weight = 1,
                   color = "#777777", fillColor = pal(selected_attribute),
                   popup = ~paste(prefecture, selected_attribute, sep = ": "))
    } else {
      leaflet(map) %>% addTiles() %>%
        setView(lat = 39, lng = 139, zoom = 5) %>%
        addPolygons(fillOpacity = 0.5, weight = 1,
                    fillColor = pal(selected_attribute),
                    popup = ~paste(prefecture)) %>%
        addLegend("bottomright", pal = pal,
                  values = selected_attribute, title = input$dynamic)
    }
  })
  
  #以下を追加
  #clusteringの部分
  data_with_cluster_number <- reactive({
    input$get_clustering
    
    number_of_cluster <- isolate(input$number_of_cluster)
    number_of_columns <- isolate(input$data_for_clustering)
    
    validate(need(length(number_of_columns) >= 2,
                  "クラスタリングするには2つ以上の変数を選択してください。"))
    data <- attribute_data[, number_of_columns]
    
    if (isolate(input$clustering_method) == "hclust") {
      hc <- hclust(dist(scale(data)))
      clusters <- cutree(hc, number_of_cluster)
      data <- cbind(attribute_data, cluster = clusters)
    } else{
      #select k-means
      clusters <- kmenas(scale(data), number_of_cluster)
      data <- cbind(attribute_data, cluster = clusters$cluster)
    }
    
    return(data)
    
  })
  
  output$table_with_cluster <- renderTable(data_with_cluster_number())
  
  #クラスタ結果を二次元プロット
  observeEvent(input$get_plot, {
    data_for_plot <- data_with_cluster_number()[, c(input$plot_x, input$plot$y)]
    
    output$plot_with_cluster <- renderPlot({
      plot(data_for_plot, col = data_with_cluster_number()$cluster, pch = 20,
           cex = 3)
    })
  })
  
  #二次元プロット上の情報表示
  output$info <- renderPrint({
    brushedPoints(data_with_cluster_number(), input$plot_brush,
                  xvar = input$plot_x, yvar = input$plot_y)
  })
  
  #クラスタ結果を地図に反映
  output$with_cluster <- renderLeaflet({
    pal <- colorFactor("Set1", domain = data_with_cluster_number()$cluster)
    leaflet(map) %>% addTiles() %>% #マップの中心
      setView(lat = 39, lng = 139, zoom = 5) %>%
      addPolygons(fillOpacity = 0.5, weight = 1,
                  fillColor = pal(data_with_cluster_number()$cluster),
                  stroke = FALSE) %>%
      addLegend("bottomright", pal = pal,
                values = data_with_cluster_number()$cluster, title = "cluster")
  })
})

shinyApp(ui = ui, server = server)


##########################
# tabBox()のサンプルコード
##########################

dashboardBody(
  tabItems(
    tabItem(tabName = "tab_A", titlePanel("tab_Aの中身"),
            box(
              title = "便の数を指定",
              footer = "フッターの部分",
              status = "info", solidHeader = FALSE,
              sliderInput("bins", "Nuber of bins:", min = 1, max = 50, value = 30)
            ),
            tabBox(
              title = "tabBoxの例",
              tabPanel("Tab1", plotOutput("distplot")),
              tabPanel("Tab2", "Tab content 2")
            )
    ),
    tabItem(tabName = "tab_B", titlePanel("tab_Bの中身"))
  )
)

#####################################################
# CHAPTER05
# GoogleアナリティクスAPIを使ったShinyアプリケーション
#####################################################

#########################
# SECTION 29 データ取得
#########################

###########################
# 01-app-version1.0 / ui.R
###########################
#install.packages("googleAuth")

library(shiny)

ui <- shinyUI(
  navbarPage("Shiny-GoogleアナリティクスAPI",
             
             tabPanel("Googleアカウント連携", tabName = "setup",
                      icon = icon("cogs")),
             
             tabPanel("メトリクスとディメンジョン",
                      tabName = "calc_metrics",
                      icon = icon("calculator"))
             
  )
)

server <- shinyServer(function(input, output, session) {})

shinyApp(ui = ui, server = server)

###############################
# 02-app-version2.0 / global.R
###############################
library(shiny)
library(googleAuthR)
library(googleAnalyticsR)

options(shiny.port = 1221)
options(googleAuthR.webapp.client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com")
options(googleAuthR.webapp.client_secret = "xxxxxxxxxxxxxxxxxxxxxxx")
options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/analytics.readony"))

###############################
# 02-app-version2.0 / ui.R
###############################

ui <- shinyUI(
  navbarPage("Shiny-Googleアナリティクス API",
             tabPanel("Googleアカウント連携", tabName = "setup", icon = icon("cags"),
                      h1("Setup"),
                      googleAuthUI("Google_login"),
                      authDropdownUI("viewId_select")),
             tabPanel("メトリクスとディメンション", tabName = "calc_metrics",
                      icon = icon("bar-chart-o"))
             )
)

##############################
# 02-app-version / server.R
##############################

server <- shinyServer(function(input, output){
  token <- callModule(googleAuth, "google_login")
  
  ga_accounts <- reactive({
    validate(
      need(token(), "Googleアカウントと連携してください。")
    )
    with_shiny(ga_account_list, shiny_access_token = token())
  })
  
  selected_id <- callModule(authDropdown, "viewId_select", ga.table = ga_accounts)
})

shinyApp(ui = ui, server = server)

###############################
# 03-app-version2.1 / ui.R
###############################
ui <- shinyUI(
  navbarPage("Shiny-GoogleアナリティクスAPI",
             tabPanel("Googleアカウント連携", tabName = "setup", icon = icon("cags"),
                      h1("Setup"),
                      googleAuthUI("Google_login"),
                      authDropdownUI("viewId_select")),
             tabPanel("メトリクスとディメンション", tabName = "calc_metrics",
                      h1("データを取得"),
                      fluidRow(
                        column(width = 6,
                               multi_selectUI("metrics", "メトリクスを選択")
                               ),
                        column(width = 6,
                               multi_selectUI("dimensions", "ディメンションを選択")
                               )
                      ),
                      fluidRow(
                        column(width = 6,
                               dateRangeInput("date_range", "日付を選択")
                               ),
                        column(width = 6, br())
                      ),
                      h2("表出力"),
                      actionButton("get_data", "データを取得！", icon = icon("download"),
                                   class = "btn-success"),
                      br(),
                      DT::dataTableOutput("data_table")
                      )
             )
)

###############################
# 03-app-version2.1 / server.R
###############################
server <- shinyServer(function(input, output, session) {
  token <- callModule(googleAuth, "Google_login")
  
  ga_accounts <- reactive({
    validate(need(token(), "Googleアカウントと連携してください"))
    with_shiny(ga_account_list, shiny_access_token = token())
  })
  
  selected_id <- callModule(authDropdown, "viewId_select", 
                            ga.table = ga_accounts)
  
  # 以下追加部分
  selected_dimensions <- callModule(multi_select, "dimensions", 
                                    type = "DIMENSION", subType = "all")
  selected_metrics <- callModule(multi_select, "metrics", type = "METRIC", 
                                 subType = "all")
  
  data_from_api <- eventReactive(input$get_data, {
    with_shiny(google_analytics, viewId = selected_id(), 
               date_range = input$date_range, metrics = selected_metrics(), 
               dimensions = selected_dimensions(), 
               shiny_access_token = token())
  })
  
  output$data_table <- DT::renderDataTable({
    dimensions_length <- length(selected_dimensions())
    data <- data_from_api()
    data_col_number <- ncol(data)
    
    data[, (dimensions_length + 1):data_col_number] <- 
      round(data[, (dimensions_length + 1):data_col_number], 3)
    
    data
  })
})

shinyApp(ui = ui, server = server)


#############################################
# SECTION-030 ggplot2を使って可視化する。
#############################################

#######################################
# SECTION-030 ggplot2を使って可視化する
#######################################
library(shiny)
library(ggplot2)

ui <- shinyUI(fluidPage(
  selectInput("sel", label = "col", choices = colnames(iris)[2:4]),
  selectInput("color", label = "col", choices = c("red", "black", "blue", "green")),
  plotOutput("plot")
))

server <- shinyServer(function(input, output){
  output$plot <- renderPlot({
    data = data.frame(x = iris[, input$sel], y = iris$Sepal.Length)
    g = ggplot(data, aes(x = x, y = y))
    g = g + geom_point(colour=input$color)
    print(g)
  })
}
)

shinyApp(ui = ui, server = server)

##############################
# 05-app-version3.0 / global.R
##############################
library(shiny)
library(googleAuthR)
library(googleAnalyticsR)
library(DT)
library(ggplot2)
library(Rmisc)

options(shiny.port = 1221)
options(googleAuthR.webapp.client_id = "xxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com")
options(googleAuthR.webapp.client_secret = "xxxxxxxxxxxxxxxxxx")
options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/analytics.readonly"))

#user for ui.R
color_choise <- c("YlOrRd", "YlOrBr", "YlGnBu", "YlGn", "Reds", "RdPu", 
                  "Purples", "PuRd", "PuBuGn", "PuBu", "OrRd", "Oranges", "Greys", "Greens", 
                  "GnBu", "BuPu", "BuGn", "Blues", "Set3", "Set2", "Set1", "Pastel2", 
                  "Pastel1", "Paired", "RColorBrewe", "Dark2", "Accent", "Spectral", 
                  "RdYlGn", "RdYlBu", "RdGy", "RdBu", "PuOr", "PRGn", "PiYG", "BrBG")

#used for server.R
modify_dimension_length_to_1 <- function(data, dimensions_length){
  paste_dim <- data[, 1]
  if (dimensions_length > 1) {
    for (i in 2:dimensions_length) {
      paste_dim <- paste(paste_dim, data[, i], sep = "-")
    }
  }
  return(paste_dim)
}

modify_dimension_length_to_2 <- function(data, dimensions_length){
  paste_dim1 <- data[, 1]
  paste_dim2 <- data[, 2]
  if (dimensions_length > 2) {
    for (i in 3:dimensions_length) {
      paste_dim2 <- paste(paste_dim2, data[, i], sep = "-")
    }
  }
  return(list(paste_dim1, paste_dim2))
}

modify_dimension_length_to_3 <- function(data, dimensions_length){
  paste_dim1 <- data[, 1]
  paste_dim2 <- data[, 2]
  paste_dim3 <- data[, 3]
  
  if (dimensions_length > 3) {
    for (i in 4:dimensions_length) {
      paste_dim3 <- paste(paste_dim3, data[, i], sep = "-")
    }
  }
  return(list(paste_dim1, paste_dim2, paste_dim3))
}

#############################
# 05-app-version3.0 / ui.R
#############################
ui <- shinyUI(
  navbarPage("Shiny - Google アナリティクス API",
             tabPanel("Google アカウント連携", tabName = "setup", icon = icon("cogs"),
                      h1("Setup"),
                      googleAuthUI("Google_login"),
                      authDropdownUI("viewId_select")),
             
             tabPanel("メトリクスとディメンション", tabName = "calc_metrics", 
                      icon = icon("bar-chart-o"),
                      h1("データを取得"),
                      fluidRow(
                        column(width = 6,
                               multi_selectUI("metrics", "メトリクスを選択")
                        ),
                        column(width = 6,
                               multi_selectUI("dimensions", "ディメンションを選択")
                        )
                      ),
                      fluidRow(
                        column(width = 6,
                               dateRangeInput("date_range", "日付を選択")
                        ),
                        column(width = 6, br())
                      ),
                      
                      h2("表出力"),
                      actionButton("get_data", "データを取得！", icon = icon("download"), 
                                   class = "btn-success"),
                      hr(),
                      DT::dataTableOutput("data_table"),
                      
                      h2("グラフ出力"),
                      br(),
                      fluidRow(
                        column(width = 6,
                               selectInput("graph_type", 
                                           label = "出力したいグラフの種類を選んでください。",
                                           choices = c("円グラフ", "棒グラフ1", "棒グラフ2", 
                                                       "折れ線グラフ", "散布図", "面グラフ"),
                                           selected = "円グラフ")),
                        column(width = 6,
                               selectInput("color_type", 
                                           label = "出力する色のタイプを選んでください。",
                                           choices = color_choise))
                      ),
                      actionButton("get_plot", "グラフを出力", icon = icon("area-chart"), 
                                   class = "btn-success"),
                      plotOutput("plot")
             )
  )
)

##############################
# 05-app-version3.0 / server.R
##############################
server <- shinyServer(function(input, output, session) {
  token <- callModule(googleAuth, "Google_login")
  
  ga_accounts <- reactive({
    validate(need(token(), "Googleアカウントと連携してください"))
    with_shiny(ga_account_list, shiny_access_token = token())
  })
  
  selected_id <- callModule(authDropdown, "viewId_select", ga.table = ga_accounts)
  
  selected_dimensions <- callModule(multi_select, "dimensions", type = "DIMENSION", 
                                    subType = "all")
  selected_metrics <- callModule(multi_select, "metrics", type = "METRIC", subType = "all")
  
  data_from_api <- eventReactive(input$get_data, {
    with_shiny(google_analytics, viewId = selected_id(), 
               date_range = input$date_range, metrics = selected_metrics(), 
               dimensions = selected_dimensions(), shiny_access_token = token())
  })
  
  output$data_table <- DT::renderDataTable({
    dimensions_length <- length(selected_dimensions())
    data <- data_from_api()
    data_col_number <- ncol(data)
    
    data[, (dimensions_length + 1):data_col_number] <- 
      round(data[, (dimensions_length + 1):data_col_number], 3)
    
    data
  })
  
  plot_list <- eventReactive(input$get_plot, {
    
    metrics_length <- length(selected_metrics())
    dimensions_length <- length(selected_dimensions())
    
    data_for_graph <- as.data.frame(data_from_api())
    data_col_number <- ncol(data_for_graph)
    
    data_for_graph[, (dimensions_length + 1):data_col_number] <- 
      round(data_for_graph[, (dimensions_length + 1):data_col_number], 3)
    
    input_graph_type <- input$graph_type
    plots <- list()
    
    # 円グラフの処理
    if (input_graph_type == "円グラフ") {
      paste_dimension <- modify_dimensions_length_to_1(data_for_graph, dimensions_length)
      
      for (i in 1:metrics_length) {
        metrics_name = colnames(data_for_graph)[(dimensions_length + i)]
        tmp_data_for_plot = data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                       dimension = paste_dimension)
        
        g <- ggplot(tmp_data_for_plot, aes(x = "", y = metrics, fill = dimension, 
                                           label = metrics))
        g <- g + geom_bar(width = 1, stat = "identity")
        g <- g + labs(title = metrics_name)
        g <- g + coord_polar("y")
        g <- g + geom_text(aes(x = "", y = metrics, label = metrics), 
                           size = 6, position = position_stack(vjust = 0.5))
        g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
        g <- g + scale_fill_brewer(palette = input$color_type)
        
        plots[[i]] <- g
      }
      
      return(plots)
    }
    
    # 棒グラフ1 or 2の処理
    if ((input_graph_type == "棒グラフ1") || (input_graph_type == "棒グラフ2")) {
      if (dimensions_length == 1) {
        
        for (i in 1:metrics_length) {
          metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
          tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                          dimension = data_for_graph[, 1])
          
          g <- ggplot(tmp_data_for_plot, aes(x = dimension, y = metrics, fill = dimension))
          g <- g + geom_bar(width = 0.8, stat = "identity") + labs(title = metrics_name)
          g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
          g <- g + scale_fill_brewer(palette = input$color_type)
          
          plots[[i]] <- g
        }
        return(plots)
      }
      
      paste_dimension <- modify_dimensions_length_to_2(data_for_graph, dimensions_length)
      
      for (i in 1:metrics_length) {
        metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
        tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                        dimension1 = paste_dimension[[1]], 
                                        dimension2 = paste_dimension[[2]])
        
        g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics, fill = dimension2))
        
        if (input_graph_type == "棒グラフ1") {
          g <- g + geom_bar(width = 0.8, stat = "identity") + labs(title = metrics_name)
        } else {
          g <- g + geom_bar(position = "dodge", width = 0.8, stat = "identity") + 
            labs(title = metrics_name)
        }
        
        g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
        g <- g + scale_fill_brewer(palette = input$color_type)
        
        plots[[i]] <- g
      }
      return(plots)
    }
    
    
    # 折れ線グラフと面グラフの処理
    if ((input_graph_type == "折れ線グラフ") || (input_graph_type == "面グラフ")) {
      if (dimensions_length == 1) {
        for (i in 1:metrics_length) {
          metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
          tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                          dimension = data_for_graph[, 1])
          
          g <- ggplot(tmp_data_for_plot, aes(x = dimension, y = metrics))
          
          if (input_graph_type == "折れ線グラフ") {
            g <- g + geom_point() + geom_line()
            g <- g + scale_color_brewer(palette = input$color_type)
          } else {
            g <- g + geom_area()
            g <- g + scale_fill_brewer(palette = input$color_type)
          }
          g <- g + labs(title = metrics_name)
          g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
          
          plots[[i]] <- g
        }
        
        return(plots)
      }
      
      paste_dimension <- modify_dimensions_length_to_2(data_for_graph, dimensions_length)
      
      for (i in 1:metrics_length) {
        metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
        
        tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                        dimension1 = paste_dimension[[1]], 
                                        dimension2 = paste_dimension[[2]])
        
        if (input_graph_type == "折れ線グラフ") {
          g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics, color = dimension2))
          g <- g + geom_point() + geom_line()
          g <- g + scale_color_brewer(palette = input$color_type)
        } else {
          g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics))
          g <- g + geom_area(aes(group = dimension2, fill = dimension2))
          g <- g + scale_fill_brewer(palette = input$color_type)
        }
        
        g <- g + labs(title = metrics_name) + 
          theme(plot.title = element_text(size = 25, face = "bold"))
        
        plots[[i]] <- g
      }
      return(plots)
    }
    
    
    # 散布図の処理
    if (input_graph_type == "散布図") {
      if (dimensions_length == 1) {
        for (i in 1:metrics_length) {
          metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
          tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                          dimension = data_for_graph[, 1])
          g <- ggplot(tmp_data_for_plot, aes(x = dimension, y = metrics))
          g <- g + geom_point() + labs(title = metrics_name)
          g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
          g <- g + scale_color_brewer(palette = input$color_type)
          
          plots[[i]] = g
        }
        return(plots)
      }
      
      if (dimensions_length <= 2) {
        for (i in 1:metrics_length) {
          metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
          tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                          dimension1 = data_for_graph[, 1], 
                                          dimension2 = data_for_graph[, 2])
          g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics))
          g <- g + geom_point(aes(colour = dimension2)) + labs(title = metrics_name)
          g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
          g <- g + scale_color_brewer(palette = input$color_type)
          
          plots[[i]] <- g
        }
        return(plots)
      }
      
      paste_dimension <- modify_dimensions_length_to_3(data_for_graph, dimensions_length)
      
      for (i in 1:metrics_length) {
        metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
        tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                        dimension1 = paste_dimension[[1]], 
                                        dimension2 = paste_dimension[[2]], 
                                        dimension3 = paste_dimension[[3]])
        
        g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics, colour = dimension2))
        g <- g + geom_point(aes(colour = dimension2, shape = dimension3)) + 
          labs(title = metrics_name)
        g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
        g <- g + scale_color_brewer(palette = input$color_type)
        
        plots[[i]] <- g
      }
      return(plots)
    }
  })
  
  output$plot <- renderPlot({
    multiplot(plotlist = plot_list(), cols = 2)
  })
})

shinyApp(ui = ui, server = server)

#############################################
#SECTION-031 パワーポイントファイルを生成する
#############################################
#install.packages("rJava", dependencies = TRUE)
#devtools::install.github("davidgohel/ReporteRsjars")
#devtools::install_github("davidgohel/ReporteRs")

##########################
# 06-ReporteRs / ui.R
##########################
library(shiny)
library(rJava)
library(ReporteRs)

ui <- shinyUI(
  fluidPage(
    
    selectInput("select", label = "col", choices = colnames(iris)[2:4]),
    selectInput("color", label = "col", choices = c("red", "black", "blue", "green")),
    plotOutput("plot"),
    downloadButton("downloadData", "Download")
    
  )
)

#########################
# 06-ReporteRs / server.R
#########################
library(shiny)
library(DT)
library(ReporteRs)
library(rJava)
library(ggplot2)

server <- shinyServer(function(input, output, session){
  
  output_plot_fun <- reactive({
    data <- data.frame(x = iris[, input$select], y = iris$Sepal.Length)
    ggplot(data, aes(x = x, y = y)) + geom_point(colour = input$color)
  })
  
  output$plot <- renderPlot({
    print(output_plot_fun())
  })
  
  output$downloadData <- downloadHandler(filename = "testfile.pptx",
                                         content <- function(file){
                                           doc <- pptx()
                                           
                                           #Slide1
                                           doc <- addSlide(doc, "Title Slide")
                                           doc <- addTitle(doc, "Rから作ったパワポです。")
                                           doc <- addSubtitle(doc, "皆さん使ってください。")
                                           
                                           #Slide2
                                           doc <- addSlide(doc, "Title and Content")
                                           doc <- addTitle(doc, "2ページ目")
                                           doc <- addPlot(doc, fun = print,
                                                          x = output_plot_fun())
                                           writeDoc(doc, file)
                                         })
})

shinyApp(ui = ui, server = server)

###############################
# 07-app-version4.0 / global.R
###############################
library(shiny)
library(googleAuthR)
library(googleAnalyticsR)
library(DT)
library(ggplot2)
library(Rmisc)
# 以下追加箇所
library(rJava)
library(ReporteRs)

options(shiny.port = 1221)
options(googleAuthR.webapp.client_id = "xxxxxxxxxxxxx.apps.googleusercontent.com")
options(googleAuthR.webapp.client_secret = "xxxxxxxxxxxxxxxx")
options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/analytics.readonly"))

# used for ui.R
color_choise <- c("YlOrRd", "YlOrBr", "YlGnBu", "YlGn", "Reds", "RdPu", 
                  "Purples", "PuRd", "PuBuGn", "PuBu", "OrRd", "Oranges", "Greys", "Greens", 
                  "GnBu", "BuPu", "BuGn", "Blues", "Set3", "Set2", "Set1", "Pastel2", 
                  "Pastel1", "Paired", "RColorBrewe", "Dark2", "Accent", "Spectral", 
                  "RdYlGn", "RdYlBu", "RdGy", "RdBu", "PuOr", "PRGn", "PiYG", "BrBG")

# used for server.R
modify_dimensions_length_to_1 <- function(data, dimensions_length) {
  paste_dim <- data[, 1]
  if (dimensions_length > 1) {
    for (i in 2:dimensions_length) {
      paste_dim <- paste(paste_dim, data[, i], sep = "-")
    }
  }
  return(paste_dim)
}

modify_dimensions_length_to_2 <- function(data, dimensions_length) {
  paste_dim1 = data[, 1]
  paste_dim2 = data[, 2]
  if (dimensions_length > 2) {
    for (i in 3:dimensions_length) {
      paste_dim2 <- paste(paste_dim2, data[, i], sep = "-")
    }
  }
  return(list(paste_dim1, paste_dim2))
}

modify_dimensions_length_to_3 <- function(data, dimensions_length) {
  paste_dim1 = data[, 1]
  paste_dim2 = data[, 2]
  paste_dim3 = data[, 3]
  
  if (dimensions_length > 3) {
    for (i in 4:dimensions_length) {
      paste_dim3 <- paste(paste_dim3, data[, i], sep = "-")
    }
  }
  return(list(paste_dim1, paste_dim2, paste_dim3))
}

############################
# 07-app-version4.0 / ui.R
############################
ui <- shinyUI(
  navbarPage("Shiny - Google アナリティクス API",
             tabPanel("Google アカウント連携", tabName = "setup", icon = icon("cogs"),
                      h1("Setup"),
                      googleAuthUI("Google_login"),
                      authDropdownUI("viewId_select")),
             
             tabPanel("メトリクスとディメンション", tabName = "calc_metrics", 
                      icon = icon("bar-chart-o"),
                      h1("データを取得"),
                      fluidRow(
                        column(width = 6,
                               multi_selectUI("metrics", "メトリクスを選択")
                        ),
                        column(width = 6,
                               multi_selectUI("dimensions", "ディメンションを選択")
                        )
                      ),
                      fluidRow(
                        column(width = 6,
                               dateRangeInput("date_range", "日付を選択")
                        ),
                        column(width = 6, br())
                      ),
                      
                      h2("表出力"),
                      actionButton("get_data", "データを取得！", icon = icon("download"), 
                                   class = "btn-success"),
                      hr(),
                      DT::dataTableOutput("data_table"),
                      
                      h2("グラフ出力"),
                      br(),
                      fluidRow(
                        column(width = 6,
                               selectInput("graph_type", 
                                           label = "出力したいグラフの種類を選んでください。",
                                           choices = c("円グラフ", "棒グラフ1", "棒グラフ2", 
                                                       "折れ線グラフ", "散布図", "面グラフ"),
                                           selected = "円グラフ")),
                        column(width = 6,
                               selectInput("color_type", 
                                           label = "出力する色のタイプを選んでください。",
                                           choices = color_choise))
                      ),
                      actionButton("get_plot", "グラフを出力", icon = icon("area-chart"), 
                                   class = "btn-success"),
                      plotOutput("plot"),
                      
                      # 以下追加箇所
                      textInput("graph_title", label = "グラフのタイトルを入力", value = "グラフ1"),
                      h2("パワーポイントダウンロード"),
                      downloadButton('download_data', 'Download')
             )
  )
)

##############################
# 07-app-version4.0 / server.R
##############################
server <- shinyServer(function(input, output, session) {
  token <- callModule(googleAuth, "Google_login")
  
  ga_accounts <- reactive({
    validate(need(token(), "Googleアカウントと連携してください"))
    with_shiny(ga_account_list, shiny_access_token = token())
  })
  
  selected_id <- callModule(authDropdown, "viewId_select", ga.table = ga_accounts)
  
  selected_dimensions <- callModule(multi_select, "dimensions", type = "DIMENSION", 
                                    subType = "all")
  selected_metrics <- callModule(multi_select, "metrics", type = "METRIC", subType = "all")
  
  data_from_api <- eventReactive(input$get_data, {
    with_shiny(google_analytics, viewId = selected_id(), 
               date_range = input$date_range, metrics = selected_metrics(), 
               dimensions = selected_dimensions(), shiny_access_token = token())
  })
  
  output$data_table <- DT::renderDataTable({
    dimensions_length <- length(selected_dimensions())
    data <- data_from_api()
    data_col_number <- ncol(data)
    
    data[, (dimensions_length + 1):data_col_number] <- 
      round(data[, (dimensions_length + 1):data_col_number], 3)
    
    data
  })
  
  plot_list <- eventReactive(input$get_plot, {
    
    metrics_length <- length(selected_metrics())
    dimensions_length <- length(selected_dimensions())
    
    data_for_graph <- as.data.frame(data_from_api())
    data_col_number <- ncol(data_for_graph)
    
    data_for_graph[, (dimensions_length + 1):data_col_number] <- 
      round(data_for_graph[, (dimensions_length + 1):data_col_number], 3)
    
    input_graph_type <- input$graph_type
    plots <- list()
    
    # 円グラフの処理
    if (input_graph_type == "円グラフ") {
      paste_dimension <- modify_dimensions_length_to_1(data_for_graph, dimensions_length)
      
      for (i in 1:metrics_length) {
        metrics_name = colnames(data_for_graph)[(dimensions_length + i)]
        tmp_data_for_plot = data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                       dimension = paste_dimension)
        
        g <- ggplot(tmp_data_for_plot, aes(x = "", y = metrics, fill = dimension, 
                                           label = metrics))
        g <- g + geom_bar(width = 1, stat = "identity")
        g <- g + labs(title = metrics_name)
        g <- g + coord_polar("y")
        g <- g + geom_text(aes(x = "", y = metrics, label = metrics), 
                           size = 6, position = position_stack(vjust = 0.5))
        g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
        g <- g + scale_fill_brewer(palette = input$color_type)
        
        plots[[i]] <- g
      }
      
      return(plots)
    }
    
    # 棒グラフ1 or 2の処理
    if ((input_graph_type == "棒グラフ1") || (input_graph_type == "棒グラフ2")) {
      if (dimensions_length == 1) {
        
        for (i in 1:metrics_length) {
          metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
          tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                          dimension = data_for_graph[, 1])
          
          g <- ggplot(tmp_data_for_plot, aes(x = dimension, y = metrics, fill = dimension))
          g <- g + geom_bar(width = 0.8, stat = "identity") + labs(title = metrics_name)
          g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
          g <- g + scale_fill_brewer(palette = input$color_type)
          
          plots[[i]] <- g
        }
        return(plots)
      }
      
      paste_dimension <- modify_dimensions_length_to_2(data_for_graph, dimensions_length)
      
      for (i in 1:metrics_length) {
        metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
        tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                        dimension1 = paste_dimension[[1]], 
                                        dimension2 = paste_dimension[[2]])
        
        g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics, fill = dimension2))
        
        if (input_graph_type == "棒グラフ1") {
          g <- g + geom_bar(width = 0.8, stat = "identity") + labs(title = metrics_name)
        } else {
          g <- g + geom_bar(position = "dodge", width = 0.8, stat = "identity") + 
            labs(title = metrics_name)
        }
        
        g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
        g <- g + scale_fill_brewer(palette = input$color_type)
        
        plots[[i]] <- g
      }
      return(plots)
    }
    
    
    # 折れ線グラフと面グラフの処理
    if ((input_graph_type == "折れ線グラフ") || (input_graph_type == "面グラフ")) {
      if (dimensions_length == 1) {
        for (i in 1:metrics_length) {
          metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
          tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                          dimension = data_for_graph[, 1])
          
          g <- ggplot(tmp_data_for_plot, aes(x = dimension, y = metrics))
          
          if (input_graph_type == "折れ線グラフ") {
            g <- g + geom_point() + geom_line()
            g <- g + scale_color_brewer(palette = input$color_type)
          } else {
            g <- g + geom_area()
            g <- g + scale_fill_brewer(palette = input$color_type)
          }
          g <- g + labs(title = metrics_name)
          g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
          
          plots[[i]] <- g
        }
        
        return(plots)
      }
      
      paste_dimension <- modify_dimensions_length_to_2(data_for_graph, dimensions_length)
      
      for (i in 1:metrics_length) {
        metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
        
        tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                        dimension1 = paste_dimension[[1]], 
                                        dimension2 = paste_dimension[[2]])
        
        if (input_graph_type == "折れ線グラフ") {
          g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics, color = dimension2))
          g <- g + geom_point() + geom_line()
          g <- g + scale_color_brewer(palette = input$color_type)
        } else {
          g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics))
          g <- g + geom_area(aes(group = dimension2, fill = dimension2))
          g <- g + scale_fill_brewer(palette = input$color_type)
        }
        
        g <- g + labs(title = metrics_name) + 
          theme(plot.title = element_text(size = 25, face = "bold"))
        
        plots[[i]] <- g
      }
      return(plots)
    }
    
    
    # 散布図の処理
    if (input_graph_type == "散布図") {
      if (dimensions_length == 1) {
        for (i in 1:metrics_length) {
          metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
          tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                          dimension = data_for_graph[, 1])
          g <- ggplot(tmp_data_for_plot, aes(x = dimension, y = metrics))
          g <- g + geom_point() + labs(title = metrics_name)
          g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
          g <- g + scale_color_brewer(palette = input$color_type)
          
          plots[[i]] = g
        }
        return(plots)
      }
      
      if (dimensions_length <= 2) {
        for (i in 1:metrics_length) {
          metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
          tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                          dimension1 = data_for_graph[, 1], 
                                          dimension2 = data_for_graph[, 2])
          g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics))
          g <- g + geom_point(aes(colour = dimension2)) + labs(title = metrics_name)
          g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
          g <- g + scale_color_brewer(palette = input$color_type)
          
          plots[[i]] <- g
        }
        return(plots)
      }
      
      paste_dimension <- modify_dimensions_length_to_3(data_for_graph, dimensions_length)
      
      for (i in 1:metrics_length) {
        metrics_name <- colnames(data_for_graph)[(dimensions_length + i)]
        tmp_data_for_plot <- data.frame(metrics = data_for_graph[, (dimensions_length + i)], 
                                        dimension1 = paste_dimension[[1]], 
                                        dimension2 = paste_dimension[[2]], 
                                        dimension3 = paste_dimension[[3]])
        
        g <- ggplot(tmp_data_for_plot, aes(x = dimension1, y = metrics, colour = dimension2))
        g <- g + geom_point(aes(colour = dimension2, shape = dimension3)) + 
          labs(title = metrics_name)
        g <- g + theme(plot.title = element_text(size = 25, face = "bold"))
        g <- g + scale_color_brewer(palette = input$color_type)
        
        plots[[i]] <- g
      }
      return(plots)
    }
  })
  
  output$plot <- renderPlot({
    multiplot(plotlist = plot_list(), cols = 2)
  })
  
  output$download_data <- downloadHandler(
    filename <- "shiny.pptx",
    content <- function(file){
      doc <- pptx()
      doc <- addSlide(doc, "Title Slide")
      doc <- addTitle(doc,"Shinyで作ったパワーポイントです")
      doc <- addSubtitle(doc, "Google アナリティクスのデータを可視化")
      
      for (i in 1:length(plot_list())){
        doc <- addSlide(doc, "Title and Content")
        doc <- addTitle(doc, input$graph_title)
        doc <- addPlot(doc, fun = print, x = plot_list()[[i]])
      }
      
      writeDoc(doc, file)
    }
  )
})

shinyApp(ui = ui, server = server)

###########################################
# CHAPTER06 Shinyアプリケーションを公開する
###########################################





