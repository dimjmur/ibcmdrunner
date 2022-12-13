// Автор А.С.Бобылкин alex_bob@lipetsk.ru
// В работе использовались файлы из пакета bsl-parser
//    https://github.com/bia-technologies/bsl-parser
// Скрипт для автогенерации документации программного интерфейса 
// классов и модулей библиотек на oscript.
// В скрипте задается путь к файлу lib.config, оттуда берутся
// имена и пути к классам и модулям библиотеки.
// В документацию включаются экспортные методы, содержащиеся внутри
// области ПрограммныйИнтерфейс.
// Описания методов должны соответствовать стандартам 1С.
// Дополнительно можно разбивать область ПрограммныйИнтерфейс на подразделы
// с помощью конструкции "// #Область <НазваниеРаздела>" и "// #КонецОбласти".
// Можно организовать вложенность подразделов, вставив перед названием раздела
// два пробела.

#Использовать "bsl-parser"

Перем ИмяБиблиотеки;
Перем ИмяМодуля;
Перем ТипОбъекта;
Перем ИмяОбъекта;
Перем ПрефиксНумерацииРазделов;
Перем СодержимоеТаблицыМетодов;
Перем СодержимоеТаблицыМетодов_МД;
Перем ПолноеИмяРаздела;

Процедура НачалоСтраницыdocMD()
	СодержимоеТаблицыМетодов_МД = Новый ТекстовыйДокумент();
	Стр = "# Программный интерфейс библиотеки " + ИмяБиблиотеки + "
	|
	|Ниже приведен полный список доступных методов классов и модулей библиотеки " + ИмяБиблиотеки + ".
	|Щелкните по имени метода для перехода к детальному описанию.
	|";
	СодержимоеТаблицыМетодов_МД.ДобавитьСтроку(Стр);
КонецПроцедуры	
Процедура НачалоСтраницыIndexHTML()
	СодержимоеТаблицыМетодов = Новый ТекстовыйДокумент();
	Стр = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">
	|<head>
	|  <title>Программный интерфейс библиотеки " + ИмяБиблиотеки + "</title>
	|  <meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">
	|  <link href=""css/default.css"" rel=""stylesheet"" type=""text/css"">
	|</head>
	|
	|<body>
	|<h1>Программный интерфейс библиотеки " + ИмяБиблиотеки + "</h1>
	|<p>Ниже приведен полный список доступных методов классов и модулей библиотеки " + ИмяБиблиотеки + ".&nbsp;
	|Щелкните по имени метода для перехода к детальному описанию.</p>
	|<p>&nbsp;</p>";
	СодержимоеТаблицыМетодов.ДобавитьСтроку(Стр);
КонецПроцедуры	

Процедура ГенерацияТаблицыМетодов(БлокиМодуля)
	ТекущаяОбласть = "";
	ПрошлиПрограммныйИнтерфейс = Ложь;
	НачалоТаблицы = Истина;
	ТаблицаОткрыта = Ложь;
	Для Каждого Блок Из БлокиМодуля Цикл
		
		Если Блок.ТипБлока = ТипыБлоковМодуля.Операторы 
			ИЛИ Блок.ТипБлока = ТипыБлоковМодуля.Комментарий
			ИЛИ Блок.ТипБлока = ТипыБлоковМодуля.КонецОбласти
			ИЛИ Блок.ТипБлока = ТипыБлоковМодуля.ПустаяСтрока Тогда
			Продолжить;
		КонецЕсли;	
		Если Блок.ОписаниеБлока.ИмяРаздела = "ПрограммныйИнтерфейс" Тогда
			ПрошлиПрограммныйИнтерфейс = Истина;
			
			Если Блок.ОписаниеБлока.ИмяОбласти <> ТекущаяОбласть Тогда
				ТекущаяОбласть = Блок.ОписаниеБлока.ИмяОбласти;
				_ТекущаяОбласть = "";
				Если Сред(ТекущаяОбласть, 1, 4) = "сть " Тогда
					_ТекущаяОбласть = Сред(ТекущаяОбласть, 5);
				КонецЕсли;	
				Если Не ПустаяСтрока(_ТекущаяОбласть) Тогда
					Если ТаблицаОткрыта Тогда
						ВывестиКонецТаблицы();
					КонецЕсли;
					ВывестиИмяОбласти(_ТекущаяОбласть);
					НачалоТаблицы = Истина;
					ТаблицаОткрыта = Ложь;					
				КонецЕсли;	
			Иначе	
				
			КонецЕсли;	
			Если Не ПустаяСтрока(Блок.ОписаниеБлока.ИмяМетода) Тогда
				ВывестиОписаниеМетода(Блок.ОписаниеБлока, НачалоТаблицы);
				ВывестиОписаниеМетода_МД(Блок.ОписаниеБлока, НачалоТаблицы);
				СформироватьСтраницуМетода(Блок);
				СформироватьСтраницуМетода_МД(Блок);
				НачалоТаблицы = Ложь;
				ТаблицаОткрыта = Истина;
			КонецЕсли;	
		Иначе
			Если ПрошлиПрограммныйИнтерфейс Тогда
				Прервать;
			КонецЕсли;	
		КонецЕсли		
	КонецЦикла;	
КонецПроцедуры	

Процедура ВывестиИмяОбласти(Знач Область)
	УровеньРаздела = 1;
	Пока Лев(Область, 2) = "  " Цикл
		Область = Сред(Область, 3);
		УровеньРаздела = УровеньРаздела + 1;
	КонецЦикла;	
	УвеличитьПрефикс(УровеньРаздела);
	ВывестиЗаголовокРаздела(Область);
	ВывестиЗаголовокРаздела_МД(Область);
КонецПроцедуры	

Функция ПолучитьОписаниеМетода(Блок, ЭтоНачалоТаблицы, РасширениеФайла)
	Стр = "";
	Если ЭтоНачалоТаблицы Тогда
		Стр = "<table bordercolor=""#c0c0c0"" cellpadding=""3"" cellspacing=""0"" width=""100%"" border=""1"">
		|<tr>
		|  <th height=""16"" width=""25%""><b>Метод</b></td>
		|  <th height=""16"" width=""75%""><b>Описание</b></td>
		|</tr>";
	КонецЕсли;
	
	Стр = Стр + "<tr>
	|<td><a href=""" + ТипОбъекта + "/" + ИмяОбъекта + "/" + Блок.ИмяМетода + "." + РасширениеФайла + """>" + Блок.ИмяМетода + "</a></td>
	|<td>" + Блок.Назначение + "</td>
  	|</tr>";
	Возврат Стр;
КонецФункции	

Процедура ВывестиОписаниеМетода(Блок, ЭтоНачалоТаблицы)
	Стр = ПолучитьОписаниеМетода(Блок, ЭтоНачалоТаблицы, "htm");
	СодержимоеТаблицыМетодов.ДобавитьСтроку(Стр);
КонецПроцедуры	

Процедура ВывестиОписаниеМетода_МД(Блок, ЭтоНачалоТаблицы)
	Стр = ПолучитьОписаниеМетода(Блок, ЭтоНачалоТаблицы, "md");
	
	СодержимоеТаблицыМетодов_МД.ДобавитьСтроку(Стр);
КонецПроцедуры	

Процедура СформироватьСтраницуМетода(БлокМодуля)
	СодержимоеСтраницыМетода = Новый ТекстовыйДокумент;
	Стр = "<!DOCTYPE html>
	|<html>
	|<head>
	|<title>Метод " + БлокМодуля.ОписаниеБлока.ИмяМетода + "</title>
	|<meta charset=""utf-8"">
	|<link href=""../../css/default.css"" rel=""stylesheet"">
	|</head>
	|<body>
	|<h1 class=""small"">Программный интерфейс библиотеки " + ИмяБиблиотеки + "</h1>
	|<hr style=""height:0px"">
	|<h1>" + БлокМодуля.ОписаниеБлока.ИмяМетода + "</h1>
	|<p class=""funcdesc"">" + БлокМодуля.ОписаниеБлока.Назначение + "<br /></p>";

	Параметры = БлокМодуля.ОписаниеБлока.ПараметрыМетода;
	Стр = Стр + "<h2>Параметры:</h2>";
	Если Параметры.Количество() > 0 Тогда
		
		Стр = Стр + "<table>
		|<tr>
		|  <th height=""16"" width=""10%""><b>№ п/п</b></th>
		|  <th height=""16"" width=""20%""><b>Имя параметра</b></th>
		|  <th height=""16"" width=""10%""><b>Обязательный</b></th>
		|  <th height=""16"" width=""20%""><b>Тип параметра</b></th>
		|  <th height=""16"" width=""40%""><b>Описание</b></th>	
		|</tr>";
		Для Каждого Параметр Из Параметры Цикл
			Если Параметр.ЗначениеПоУмолчанию = Неопределено Тогда
				Обязательный = "Да";
			Иначе
				Обязательный = "Нет";
			КонецЕсли;		
			Стр = Стр + "<tr>
			|  <td >" + (Параметры.Индекс(Параметр) + 1) + "</td>
			|  <td >" + Параметр.Имя + "</td>
			|  <td >" + Обязательный + "</td>
			|  <td >" + Параметр.ТипПараметра + "</td>
			|  <td >" + Параметр.ОписаниеПараметра + "</td>	
			|</tr>";
									
		КонецЦикла;
	Иначе
		Стр = Стр + "<b>Нет. </b><br />";	
	КонецЕсли;
	Стр = Стр + "</table>";
	Стр = Стр + "<h2>Возвращаемое значение:</h2>
	|";
	Если Не ПустаяСтрока(БлокМодуля.ОписаниеБлока.ТипВозвращаемогоЗначения) Тогда
		Стр = Стр + "<b>" + БлокМодуля.ОписаниеБлока.ТипВозвращаемогоЗначения + ". </b>" 
		+ БлокМодуля.ОписаниеБлока.ОписаниеВозвращаемогоЗначения + ".<br />";
	Иначе
		Стр = Стр + "<b>Нет. </b><br />";
	КонецЕсли;
	Стр = Стр +"</body></html>";
	СодержимоеСтраницыМетода.ДобавитьСтроку(Стр);
	ИмяФайлаСтраницы = ОбъединитьПути(ТекущийКаталог(), ТипОбъекта, ИмяОбъекта, БлокМодуля.ОписаниеБлока.ИмяМетода + ".htm");
	СодержимоеСтраницыМетода.Записать(ИмяФайлаСтраницы);		
КонецПроцедуры	

Процедура СформироватьСтраницуМетода_МД(БлокМодуля)
	СодержимоеСтраницыМетода = Новый ТекстовыйДокумент;
	Стр = "
	|<h1>" + БлокМодуля.ОписаниеБлока.ИмяМетода + "</h1>
	|<p class=""funcdesc"">" + БлокМодуля.ОписаниеБлока.Назначение + "<br /></p>";

	Параметры = БлокМодуля.ОписаниеБлока.ПараметрыМетода;
	Стр = Стр + "<h2>Параметры:</h2>";
	Если Параметры.Количество() > 0 Тогда
		
		Стр = Стр + "<table>
		|<tr>
		|  <th height=""16"" width=""10%""><b>№ п/п</b></th>
		|  <th height=""16"" width=""20%""><b>Имя параметра</b></th>
		|  <th height=""16"" width=""10%""><b>Обязательный</b></th>
		|  <th height=""16"" width=""20%""><b>Тип параметра</b></th>
		|  <th height=""16"" width=""40%""><b>Описание</b></th>	
		|</tr>";
		Для Каждого Параметр Из Параметры Цикл
			Если Параметр.ЗначениеПоУмолчанию = Неопределено Тогда
				Обязательный = "Да";
			Иначе
				Обязательный = "Нет";
			КонецЕсли;		
			Стр = Стр + "<tr>
			|  <td >" + (Параметры.Индекс(Параметр) + 1) + "</td>
			|  <td >" + Параметр.Имя + "</td>
			|  <td >" + Обязательный + "</td>
			|  <td >" + Параметр.ТипПараметра + "</td>
			|  <td >" + Параметр.ОписаниеПараметра + "</td>	
			|</tr>";
									
		КонецЦикла;
	Иначе
		Стр = Стр + "<b>Нет. </b><br />";	
	КонецЕсли;
	Стр = Стр + "</table>";
	Стр = Стр + "<h2>Возвращаемое значение:</h2>
	|";
	Если Не ПустаяСтрока(БлокМодуля.ОписаниеБлока.ТипВозвращаемогоЗначения) Тогда
		Стр = Стр + "<b>" + БлокМодуля.ОписаниеБлока.ТипВозвращаемогоЗначения + ". </b>" 
		+ БлокМодуля.ОписаниеБлока.ОписаниеВозвращаемогоЗначения + ".<br />";
	Иначе
		Стр = Стр + "<b>Нет. </b><br />";
	КонецЕсли;
	
	СодержимоеСтраницыМетода.ДобавитьСтроку(Стр);
	ИмяФайлаСтраницы = ОбъединитьПути(ТекущийКаталог(), ТипОбъекта, ИмяОбъекта, БлокМодуля.ОписаниеБлока.ИмяМетода + ".md");
	СодержимоеСтраницыМетода.Записать(ИмяФайлаСтраницы);		
КонецПроцедуры	


Процедура ВывестиКонецТаблицы()
	Стр = "</table>";
	СодержимоеТаблицыМетодов.ДобавитьСтроку(Стр);
КонецПроцедуры

Процедура ВывестиЗаголовокРаздела(ИмяРаздела)
	Стр = "<h2>" + ПрефиксНумерацииРазделов + " " + ИмяРаздела + "</h2>";
	СодержимоеТаблицыМетодов.ДобавитьСтроку(Стр);
КонецПроцедуры

Процедура ВывестиЗаголовокРаздела_МД(ИмяРаздела)
	Стр = "
	|## " + ПрефиксНумерацииРазделов + " " + ИмяРаздела;
	СодержимоеТаблицыМетодов_МД.ДобавитьСтроку(Стр);
КонецПроцедуры

Процедура КонецСтраницыIndexHTML()
	Стр = "</body></html>";
	СодержимоеТаблицыМетодов.ДобавитьСтроку(Стр);
КонецПроцедуры	

Процедура УвеличитьПрефикс(Уровень)
	МассивНумерации = Новый Массив;
	Стр = ПрефиксНумерацииРазделов;
	Поз = СтрНайти(Стр,".");
	Пока Поз > 0 Цикл
		
		МассивНумерации.Добавить(Число(Лев(Стр, Поз - 1)));
		Стр = Сред(Стр, Поз + 1);
		Поз = СтрНайти(Стр,"."); 
	КонецЦикла;	
	КоличествоУровней = МассивНумерации.Количество();
	Если Уровень = КоличествоУровней Тогда
		МассивНумерации.Добавить(1);
	ИначеЕсли Уровень < КоличествоУровней Тогда
		МассивНумерации[Уровень] = МассивНумерации[Уровень]	+ 1;
		Пока МассивНумерации.Количество() > Уровень + 1 Цикл
			МассивНумерации.Удалить(МассивНумерации.Количество() - 1);
		КонецЦикла;	
	Иначе
		Сообщить("Ошибка нумерации раздела: " + ПрефиксНумерацииРазделов + " уровень " + Уровень);
		Возврат;
	КонецЕсли;		
		Стр = "";
		Для ъ = 0 По МассивНумерации.Количество() - 1 Цикл
			Стр = Стр + МассивНумерации[ъ] + ".";
		КонецЦикла;	
		ПрефиксНумерацииРазделов = Стр;	
КонецПроцедуры	

Функция ПрочитатьКонфигФайлБиблиотеки(ИмяФайла)
	ТаблицаОбъектов = Новый ТаблицаЗначений;
	ТаблицаОбъектов.Колонки.Добавить("ТипОбъекта");
	ТаблицаОбъектов.Колонки.Добавить("ИмяОбъекта");
	ТаблицаОбъектов.Колонки.Добавить("ИмяФайлаОбъекта");

	Текст = Новый ЧтениеТекста(ИмяФайла,"utf-8");
	Стр = Текст.ПрочитатьСтроку();
	Пока Стр <> Неопределено Цикл
		Поз1 = СтрНайти(Стр, "<modul ");
		Поз2 = СтрНайти(Стр, "<class ");
		Если Поз1 + Поз2 = 0 Тогда
			Стр = Текст.ПрочитатьСтроку();
			Продолжить;
		КонецЕсли;	
		Если Поз1 > 0 Тогда 
			ТипОбъекта = "Модуль";
			Стр = Сред(Стр, Поз1 + 7);
		КонецЕсли;
		Если Поз2 > 0 Тогда
			ТипОбъекта = "Класс";
			Стр = Сред(Стр, Поз2 + 7);
		КонецЕсли;
		
		Поз3 = СтрНайти(Стр,"""");
		Стр = Сред(Стр, Поз3 + 1);
		Поз4 = СтрНайти(Стр,"""");
		ИмяОбъекта = Сред(Стр, 1, Поз4 - 1);
		Стр = Сред(Стр, Поз4 + 1);
		Поз5 = СтрНайти(Стр, """");
		Стр = Сред(Стр, Поз5 + 1);
		Поз6 = СтрНайти(Стр, """");
		ИмяФайлаОбъекта = Сред(Стр, 1, Поз6 - 1);
		
		Объект = ТаблицаОбъектов.Добавить();
		Объект.ТипОбъекта = ТипОбъекта;
		Объект.ИмяОбъекта = ИмяОбъекта;
		Объект.ИмяФайлаОбъекта = ИмяФайлаОбъекта;
		Стр = Текст.ПрочитатьСтроку();
	КонецЦикла;	
	Возврат ТаблицаОбъектов;
КонецФункции	

ИмяБиблиотеки = "ibcmdrunner";

// Анализируем lib.config
ИмяКонфигФайла = ОбъединитьПути(Сред(ТекущийКаталог(), 1, СтрДлина(ТекущийКаталог())-4), "lib.config");
ТаблицаОбъектов = ПрочитатьКонфигФайлБиблиотеки(ИмяКонфигФайла);

СтрокаМодуля = Новый Структура("ТипМодуля, ОписаниеМодуля", ТипыМодуля.ОбщийМодуль, "");

НачалоСтраницыIndexHTML();
НачалоСтраницыdocMD();
ПрефиксНумерацииРазделов = "1.";

Для Каждого Объект Из ТаблицаОбъектов Цикл
	ИмяОбъекта = Объект.ИмяОбъекта;
	ТипОбъекта = Объект.ТипОбъекта;
	КаталогМетодовОбъекта = ОбъединитьПути(ТекущийКаталог(), ТипОбъекта, ИмяОбъекта);
	ФайлОбъекта = ОбъединитьПути(Сред(ТекущийКаталог(), 1, СтрДлина(ТекущийКаталог())-4), Объект.ИмяФайлаОбъекта);
	Результат = ЧтениеМодулей.ПрочитатьМодуль(ФайлОбъекта, СтрокаМодуля);
	Файл = Новый Файл(КаталогМетодовОбъекта);
	Если Файл.Существует() И Файл.ЭтоКаталог() Тогда
		УдалитьФайлы(КаталогМетодовОбъекта, "*.*");
	Иначе
		КаталогТипаОбъекта = ОбъединитьПути(ТекущийКаталог(), ТипОбъекта);
		Если Файл.Существует() И Файл.ЭтоКаталог() Тогда
		Иначе
			СоздатьКаталог(КаталогТипаОбъекта);	
		КонецЕсли;		
		СоздатьКаталог(КаталогМетодовОбъекта);
	КонецЕсли;	 
	ВывестиЗаголовокРаздела(ТипОбъекта + ": " + ИмяОбъекта);
	ВывестиЗаголовокРаздела_МД(ТипОбъекта + ": " + ИмяОбъекта);
	ГенерацияТаблицыМетодов(Результат.БлокиМодуля);
	ВывестиКонецТаблицы();
	УвеличитьПрефикс(0);
КонецЦикла;	

КонецСтраницыIndexHTML();
СодержимоеТаблицыМетодов.Записать("index.htm");
СодержимоеТаблицыМетодов_МД.Записать("doc.md");