﻿
&НаСервере
Функция ПодпискиКонтрагентПриИзмененииНаСервере(Контрагент)
	
	Номенклатура = Контрагент.бизОсновнойПП1С.Номенклатура;
	РегНомер = Контрагент.бизОсновнойПП1С.РегНомер;
	
	//Отобрать все продукты 1С по владельцу и суммировать их
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец",Контрагент);
	Запрос.Текст =  "ВЫБРАТЬ
	                |	бизПП1С.Владелец,
	                |	СУММА(бизПП1С.КоличествоРабМест) КАК КоличествоРабМест
	                |ИЗ
	                |	Справочник.бизПП1С КАК бизПП1С
	                |ГДЕ
	                |	бизПП1С.Владелец = &Владелец
	                |
	                |СГРУППИРОВАТЬ ПО
	                |	бизПП1С.Владелец";
	 Выборка = Запрос.Выполнить().Выбрать();
	 Если Выборка.Следующий() Тогда
		 КоличествоРабМест = Выборка.КоличествоРабМест;	 
	 КонецЕсли;
	 
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	                |	бизПодпискиСрезПоследних.ВидПодписки
	                |ИЗ
	                |	РегистрСведений.бизПодписки.СрезПоследних КАК бизПодпискиСрезПоследних
	                |ГДЕ
	                |	бизПодпискиСрезПоследних.Контрагент = &Контрагент";
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		 ВидПодписки = Выборка.ВидПодписки;	 
	 КонецЕсли;
	
	Возврат Новый Структура ("Номенклатура, РегНомер, КонтактноеЛицо, КоличествоРабМест, ВидПодписки", Номенклатура, РегНомер,Контрагент.КонтактноеЛицо,КоличествоРабМест, ВидПодписки);
КонецФункции

&НаКлиенте
Процедура ПодпискиСрокПодпискиПриИзменении(Элемент)
	
 ПолучитьУстановитьДатуОкончанияПодписки();

КонецПроцедуры


&НаКлиенте
Процедура ПодпискиДатаНачалаПодпискиПриИзменении(Элемент)
	Элементы.Подписки.ТекущиеДанные.ДатаНачалаПодписки = НачалоМесяца(Элементы.Подписки.ТекущиеДанные.ДатаНачалаПодписки);	
	ПолучитьУстановитьДатуОкончанияПодписки();

КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура ПолучитьУстановитьДатуОкончанияПодписки()

	КолвоМесяцев = ПолучитьКоличествоМесяцев(Элементы.Подписки.ТекущиеДанные.СрокПодписки);
		
	Если КолвоМесяцев <> 0 Тогда
		Элементы.Подписки.ТекущиеДанные.ДатаОкончанияПодписки = КонецМесяца(ДобавитьМесяц(Элементы.Подписки.ТекущиеДанные.ДатаНачалаПодписки, КолвоМесяцев) - 1);
	КонецЕсли; 


КонецПроцедуры // ПолучитьУстановитьДатуОкончанияПодписки()



// Вернуть количество месяцев в периоде подписки
//
// Параметры
//  СрокПодписки  – <Перечисление.бизСрокиПодписокИТС>
//
Функция ПолучитьКоличествоМесяцев(СрокПодписки) Экспорт
 
 	КолвоМесяцев = 0;
	Если СрокПодписки = ПредопределенноеЗначение("Перечисление.бизСрокиПодписокИТС.Месяц") Тогда
		КолвоМесяцев = 1;
	ИначеЕсли СрокПодписки = ПредопределенноеЗначение("Перечисление.бизСрокиПодписокИТС.Квартал") Тогда
		КолвоМесяцев = 3;
	ИначеЕсли СрокПодписки = ПредопределенноеЗначение("Перечисление.бизСрокиПодписокИТС.Полугодие") Тогда
		КолвоМесяцев = 6;
	ИначеЕсли СрокПодписки = ПредопределенноеЗначение("Перечисление.бизСрокиПодписокИТС.Год") Тогда
		КолвоМесяцев = 12;
	КонецЕсли;
	
	Возврат КолвоМесяцев;
 
КонецФункции


&НаКлиенте
Процедура ПодпискиОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//Получить форму выбора и если поле контрагент в табличной части Подписки заполнено установить параметры отбора по контрагенту
	ФормаВыбора = ПолучитьФорму("Справочник.КонтактныеЛица.ФормаВыбора",,Элемент);
	Контрагент = Элементы.Подписки.ТекущиеДанные.Контрагент;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ЭлементОтбора = ФормаВыбора.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = ФормаВыбора.Список.Отбор.ДоступныеПоляОтбора.Элементы.Найти("Владелец").Поле;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ПравоеЗначение = Контрагент;
	КонецЕсли;
	
	ФормаВыбора.Открыть();
	
КонецПроцедуры


&НаКлиенте
Процедура ПодпискиВидПодпискиПриИзменении(Элемент)
	ТекущаяПодписка = Элементы.Подписки.ТекущиеДанные;
	ВидПодписки = ТекущаяПодписка.ВидПодписки;
	ТекущаяПодписка.ВидОплаты = ПолучитьЗначениеВидаОплаты(ВидПодписки);
	КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервереБезКонтекста
Функция ПолучитьЗначениеВидаОплаты(ВидПодписки)

	Если ВидПодписки = Справочники.бизВидыПодписок.ИТСПроф1DVDБесплатный	Тогда
		
	Возврат Перечисления.бизВидыОплатыИТС.Помесячно;
	Иначе  Возврат Перечисления.бизВидыОплатыИТС.Сразу;
	КонецЕсли;

КонецФункции // ПолучитьЗначениеВидаОплаты()

&НаСервереБезКонтекста
Функция ПолучитьЗначениеВидаОперации()

Возврат Перечисления.бизОперацииИТС.ЗарегистрироватьПодписку;	

КонецФункции // ПолучитьЗначениеВидаОперации()



&НаКлиенте
Процедура СоздатьФайл(Команда)
	СоздатьФайлНаСервере();
	ЗапретитьСоздатьФайл();
КонецПроцедуры


&НаСервере
Процедура СоздатьФайлНаСервере()
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДвоичныеДанные = ДокументОбъект.СоздатьФайлExcel();
	АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные,ЭтаФорма.УникальныйИдентификатор);
	ЗначениеВДанныеФормы(ДокументОбъект, Объект);	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ЗапуститьПриложение(ПолучитьИмяФайлаНаКлиенте());

КонецПроцедуры


&НаСервере
Функция ПолучитьИмяФайла()
 ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайла);
 ИмяФайла = КаталогВременныхФайлов()+СокрЛП(Объект.Организация.бизКодПартнера)+".xls";
 ДвоичныеДанные.Записать (ИмяФайла);
 Возврат ИмяФайла;
КонецФункции

&НаКлиенте
Функция ПолучитьИмяФайлаНаКлиенте()
 ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайла);
 КодПартнера = ПолучитьКодПартнераНаСервере(Объект.Организация);
 ИмяФайла = КаталогВременныхФайлов()+КодПартнера+".xls";
 ДвоичныеДанные.Записать (ИмяФайла);
 Возврат ИмяФайла;
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
ЗапретитьСоздатьФайл();
мРазделительАдресов =  ",";
УстановитьЗначенияПоУмолчанию();
УправлениеВидимостьюДистрибутора();
Месяц       = НачалоМесяца(ТекущаяДата());
МесяцСтрока = Формат(Месяц, "ДФ='ММММ гггг'");
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура ЗапретитьСоздатьФайл()
	
	Если АдресФайла = "" Тогда
		Элементы.ФормаОткрытьФайл.Доступность = Ложь;
		Элементы.ФормаСоздатьПисьмо.Доступность = Ложь;
	Иначе Элементы.ФормаОткрытьФайл.Доступность = Истина;
		  Элементы.ФормаСоздатьПисьмо.Доступность = Истина;
	КонецЕсли

КонецПроцедуры // ЗапретитьСоздатьФайл()

&НаКлиенте
Процедура СоздатьПисьмо(Команда)
	Попытка
		Outlook = Новый COMОбъект("Outlook.Application");
		ЕстьОшибка = 0;
	Исключение
		Предупреждение("Не удалось создать объект Outlook.Application");
		ЕстьОшибка = 1;
	КонецПопытки;
	
	Если ЕстьОшибка = 0 Тогда
		
		Письмо = Outlook.CreateItem(0);
		Письмо.Subject = "ip"+Лев(ПолучитьКодПартнераНаСервере(Объект.Организация),5);
		Письмо.Body = "";
		Письмо.Recipients.Add("robotits@1c.ru");
		ПутьКВложению = ПолучитьИмяФайлаНаКлиенте();
		Письмо.Attachments.Add(ПутьКВложению);
		Письмо.Display();
	Иначе
		Тема = "";
		ТекстПисьма = "";
		Адрес = "";
		СтрокаЗапуска = "mailto:" + Адрес + "?subject=" + Тема + "&body=" + ТекстПисьма;
		ЗапуститьПриложение(СтрокаЗапуска);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКодПартнераНаСервере(Организация)
	Возврат СокрЛП(Организация.бизКодПартнера);
КонецФункции // ПолучитьКодПартнераНаСервере()


&НаКлиенте
Процедура СпособПолученияПриИзменении(Элемент)
	УправлениеВидимостьюДистрибутора ();
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостьюДистрибутора()
	Если Объект.СпособПолучения = 1 Тогда
		Элементы.КодДистрибутора.Видимость = Истина;
	Иначе	
		Элементы.КодДистрибутора.Видимость = Ложь;		
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()
Если НЕ ЗначениеЗаполнено(Объект.СпособПолучения)Тогда
Объект.СпособПолучения = Константы.бизСпособДоставки.Получить();
КонецЕсли;

Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
Объект.Организация = Справочники.Организации.ОсновнаяОрганизация;	
КонецЕсли;

Если НЕ ЗначениеЗаполнено(Объект.СтатусЗаявки) Тогда
Объект.СтатусЗаявки = Перечисления.бизСтатусыЗаявкиИТС.Открыта;	
КонецЕсли;

Если НЕ ЗначениеЗаполнено(Объект.КодДистрибутора) Тогда
Объект.КодДистрибутора = Константы.бизКодДистрибутора.Получить();
КонецЕсли;

Если НЕ ЗначениеЗаполнено(Объект.Кому) Тогда
Объект.Кому = Константы.бизАдресЭлектроннойПочтыЗаявокИТС.Получить();
КонецЕсли;
КонецПроцедуры // УстановитьЗначенияПоУмолчанию()

&НаКлиенте
Процедура ЗаполнитьПоЗавершенным(Команда)
	ЗаполнитьПоЗавершеннымНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоЗавершеннымНаСервере()
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьПоЗавершенным(Месяц, ЧислоМесяцев);
	ЗначениеВДанныеФормы(ДокументОбъект, Объект);
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Месяц", "МесяцСтрока", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Месяц", "МесяцСтрока");
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Месяц", "МесяцСтрока", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗаявкаЗарегистрирована" Тогда;
		ЭтаФорма.Прочитать();
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура СоздатьЗаказыНаСервере()
	
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	ДокОбъект.Записать();
		
	Для каждого Подписка Из ДокОбъект.Подписки Цикл
		Если Подписка.Отметка Тогда
			//Создать документ Заказ покупателя, если он еще не создан
			НайденныеСтроки = ДокОбъект.ДокументыНаОплату.НайтиСтроки(Новый Структура ("ЗаказПокупателя", Подписка.ЗаказПокупателя));
			Если НайденныеСтроки.Количество()>0 Тогда
				ДокОплатыСтр = НайденныеСтроки[0];
				ЗаказПокупателя = НайденныеСтроки[0].ЗаказПокупателя.ПолучитьОбъект();
			ИначеЕсли  НайденныеСтроки.Количество() = 0 Тогда
				ДокОплатыСтр = ДокОбъект.ДокументыНаОплату.Добавить();
				ЗаказПокупателя = Документы.ЗаказПокупателя.СоздатьДокумент();
			КонецЕсли;			
			ДокОплатыСтр.Контрагент = Подписка.Контрагент;
			ЗаказПокупателя.Дата = ДокОбъект.Дата;
			Организация =  ДокОбъект.Организация;
			ЗаказПокупателя.Организация = Организация;
			ЗаказПокупателя.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу;
			ЗаказПокупателя.СостояниеЗаказа = Справочники.СостоянияЗаказовПокупателей.НайтиПоНаименованию("В работе");
			//ЗаказПокупателя.Закрыт = Ложь;
			ЗаказПокупателя.ПоложениеДатыОтгрузки = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
			Контрагент = Подписка.Контрагент;
			ЗаказПокупателя.Контрагент = Контрагент;
			ЗаказПокупателя.Договор = Контрагент.ДоговорПоУмолчанию;
			ЗаказПокупателя.БанковскийСчет =  Организация.БанковскийСчетПоУмолчанию;
			ЗаказПокупателя.ВалютаДокумента = Константы.ВалютаУчета.Получить();
			ЗаказПокупателя.ВидЦен = Справочники.ВидыЦен.НайтиПоНаименованию("Оптовая цена");
			ЗаказПокупателя.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС;
			ЗаказПокупателя.Курс = 1;
			ЗаказПокупателя.Кратность = 1;
			ЗаказПокупателя.ДатаОтгрузки = КонецМесяца(Подписка.ДатаОкончанияПодписки);
			ТекПользователь = ПараметрыСеанса.АвторизованныйПользователь;
			ЗаказПокупателя.Автор = ТекПользователь = ТекПользователь;
			ЗаказПокупателя.Ответственный = бизСлужебныйНаСервере.ПолучитьСсылкуНаСотрудникаПользователя(ТекПользователь);
			//ЗаказПокупателя.Комментарий = СтрШаблон("Сформировано автоматически из документа ""Заявка на ИТС №%1 от %2""", ДокОбъект.Номер, Формат(ДокОбъект.Дата, "ДФ=dd.MM.yyyy"));
			
			//По коду и периоду подписки определить номенклатуру подписки из регистра Оплата подписок ИТС
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	бизОплатаИТССрезПоследних.НоменклатураПодписки,
			               |	бизОплатаИТССрезПоследних.Цена
			               |ИЗ
			               |	РегистрСведений.бизОплатаИТС.СрезПоследних(&ДатаСреза, ) КАК бизОплатаИТССрезПоследних
			               |ГДЕ
			               |	бизОплатаИТССрезПоследних.ВидПодписки = &ВидПодписки
			               |	И бизОплатаИТССрезПоследних.СрокПодписки = &СрокПодписки";
			Запрос.УстановитьПараметр("ДатаСреза",ДокОбъект.Дата);
			Запрос.УстановитьПараметр("ВидПодписки", Подписка.ВидПодписки);
			Запрос.УстановитьПараметр("СрокПодписки", Подписка.СрокПодписки);
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				ВыборкаДЗ = РезультатЗапроса.Выбрать();
				Пока ВыборкаДЗ.Следующий() Цикл
					ЗаказПокупателя.Запасы.Очистить();
					СтрЗапасы = ЗаказПокупателя.Запасы.Добавить();
					НоменклатураПодписки = ВыборкаДЗ.НоменклатураПодписки;
					СтрЗапасы.Номенклатура = НоменклатураПодписки;
					СтрЗапасы.Содержание = НоменклатураПодписки.НаименованиеПолное;
					СтрЗапасы.ТипНоменклатурыЗапас = Ложь;
					СтрЗапасы.Количество = бизУчетИТСКлиентСервер.ПолучитьКолвоМесяцев(Подписка.СрокПодписки);
					СтрЗапасы.ЕдиницаИзмерения = НоменклатураПодписки.ЕдиницаИзмерения;
					СтрЗапасы.Цена  =  ВыборкаДЗ.Цена;
					СтрЗапасы.СтавкаНДС = Справочники.СтавкиНДС.НайтиПоНаименованию("Без НДС");
					СтрЗапасы.СуммаНДС = 0;
					СтрЗапасы.ДатаОтгрузки = КонецМесяца(Подписка.ДатаОкончанияПодписки);
					СтрЗапасы.Сумма = СтрЗапасы.Количество * СтрЗапасы.Цена;
					СтрЗапасы.Всего = СтрЗапасы.Сумма;
				КонецЦикла;
			КонецЕсли;
			
			СуммаДокумента = ЗаказПокупателя.Запасы.Итог("Всего");
			
			//Запланировать 100% предоплаты для клиентов по ИТС
			ЗаказПокупателя.ЗапланироватьОплату = Истина;
			ЗаказПокупателя.ТипДенежныхСредств = Перечисления.ТипыДенежныхСредств.Безналичные;
			ЗаказПокупателя.ПлатежныйКалендарь.Очистить();
			СтрПлатежКалендаря = ЗаказПокупателя.ПлатежныйКалендарь.Добавить();
			СтрПлатежКалендаря.ДатаОплаты = КонецМесяца(ДобавитьМесяц(Подписка.ДатаНачалаПодписки,-1));
			СтрПлатежКалендаря.ПроцентОплаты = 100;
			СтрПлатежКалендаря.СуммаОплаты = СуммаДокумента;
			
			ЗаказПокупателя.СуммаДокумента = СуммаДокумента;
			
			//Записать документ Заказ покупателя, а ссылку записать в ТЧ Подписки для дальнейшего поиска в ТЧ ДокументыНаОплату
			ЗаказПокупателя.Записать(РежимЗаписиДокумента.Проведение);
			ДокОплатыСтр.ЗаказПокупателя = ЗаказПокупателя.Ссылка;
			Подписка.ЗаказПокупателя = ЗаказПокупателя.Ссылка;
			
		КонецЕсли;
	КонецЦикла;
	ДокОбъект.Записать();	
	ЗначениеВРеквизитФормы(ДокОбъект,"Объект");

КонецПроцедуры


&НаКлиенте
Процедура СоздатьЗаказы(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)Тогда
	    ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьВыборПользователя",ЭтаФорма),"Для продолжения необходимо записать документа",РежимДиалогаВопрос.ДаНет);	
	Иначе СоздатьЗаказыНаСервере();  	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборПользователя(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		СоздатьЗаказыНаСервере();
	КонецЕсли;
	

КонецПроцедуры // ОбработатьВыборПользователя()

&НаКлиенте
Процедура СоздатьДокументыОтправки(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВДинамическомСписке(Команда)
	ТекДанные = Элементы.ДокументыНаОплату.ТекущиеДанные;
	Если ТекДанные = Неопределено  Тогда
	    Возврат;                                    	
	КонецЕсли;
		
	УправлениеНебольшойФирмойКлиент.ИзменитьЭлементОтбораСписка(СписокСобытийЕмэйл, "ДокументОснование", ТекДанные.ЗаказПокупателя, ТекДанные <> Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыНаОплатуПриАктивизацииСтроки(Элемент)
	УстановитьОтборВСпискеДокументовОтправки();// Вставить содержимое обработчика.
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура УстановитьОтборВСпискеДокументовОтправки()

	ТекДанные = Элементы.ДокументыНаОплату.ТекущиеДанные;
	Если ТекДанные = Неопределено  Тогда
	    Возврат;                                    	
	КонецЕсли;
		
	УправлениеНебольшойФирмойКлиент.ИзменитьЭлементОтбораСписка(СписокСобытийЕмэйл, "ДокументОснование", ТекДанные.ЗаказПокупателя, ТекДанные <> Неопределено);

КонецПроцедуры // УстановитьОтборВСпискеДокументовОтправки()

&НаКлиенте
Процедура ПодпискиКонтрагентПриИзменении(Элемент)
	
	ТекДанные = Элементы.Подписки.ТекущиеДанные;
	ДанныеПодписки = ПодпискиКонтрагентПриИзмененииНаСервере(ТекДанные.Контрагент);
	ТекДанные.Номенклатура = ДанныеПодписки.Номенклатура;
	ТекДанные.РегистрационныйНомер = ДанныеПодписки.РегНомер;
	ТекДанные.ВидПодписки = ДанныеПодписки.ВидПодписки;
	ТекДанные.Руководитель = ДанныеПодписки.КонтактноеЛицо;
	
КонецПроцедуры



