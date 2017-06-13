﻿
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.КлючНазначенияИспользования <> "Просроченные" 
		И Параметры.КлючНазначенияИспользования <> "ОжидаютВыполнения"  Тогда
		Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация =УправлениеНебольшойФирмойСервер.ПолучитьПредопределеннуюОрганизацию();
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("Задача") Тогда
		Задача = Параметры.Задача;
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "Задача", Задача, ЗначениеЗаполнено(Задача));
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	СписокЗадач.КомпоновщикНастроек.ЗагрузитьФиксированныеНастройки(НастройкиОформленияСпискаЗадач());
	
	МассивРасчетныхЗадач = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ПолучитьМассивРасчетныхЗадач();
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "Организация", Организация, ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокЗадач, "МассивРасчетныхЗадач", МассивРасчетныхЗадач);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокЗадач, "ТекущаяДата", ТекущаяДатаСеанса());
	
	ТекущийТипОтображения = 0;
	Элементы.СписокЗадачОсталосьДней.Видимость = Истина;
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "ЭтоБудущаяЗадача", Ложь, Истина);
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "СобытиеЗавершено", Ложь, Истина);
	
	Если Параметры.КлючНазначенияИспользования = "Просроченные" Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + НСтр("ru=': просроченные'");
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "ОсталосьДней", 0, Истина, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
	ИначеЕсли Параметры.КлючНазначенияИспользования = "ОжидаютВыполнения" Тогда
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "ОсталосьДней", 0, Истина, ВидСравненияКомпоновкиДанных.Больше);
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + НСтр("ru=': ожидают выполнения'");
	КонецЕсли;
	ЗапуститьОбновлениеДанныхНаСервере();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЖдатьЗавершенияФоновогоЗадания();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "Организация", Организация, ЗначениеЗаполнено(Организация));
	
	Если ЗапуститьОбновлениеДанныхНаСервере() Тогда
		
		ЖдатьЗавершенияФоновогоЗадания();
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗадачаПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "Задача", Задача, ЗначениеЗаполнено(Задача));
	
	Если ЗапуститьОбновлениеДанныхНаСервере() Тогда
		
		ЖдатьЗавершенияФоновогоЗадания();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадач(Команда)
	
	Если ЗапуститьОбновлениеДанныхНаСервере() Тогда
		
		ЖдатьЗавершенияФоновогоЗадания();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВАрхив(Команда)
	
	ТекДанные = Элементы.СписокЗадач.ТекущиеДанные;
	
	Если ТекДанные <> Неопределено Тогда
		ПеренестиЗадачуВАрхивСервер(ТекДанные.Организация, ТекДанные.СобытиеКалендаря);
		Элементы.СписокЗадач.Обновить();
	КонецЕсли;
	
	СписокЗадачПустой = СписокЗадачПустой(Организация, ПоказыватьЗавершенные, ПоказыватьБудущие, Задача);
	
	Если СписокЗадачПустой Тогда
		УправлениеФормой(ЭтаФорма, Организация, Задача);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПредупрежденияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ОткрытьФорму("Справочник.Организации.ФормаОбъекта", Новый Структура("Ключ,ЗадачаОтчетности", Организация, Задача));
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Декорация4ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиВАрхив" Тогда
		ПоказыватьБудущие = Ложь;
		ПоказыватьЗавершенные = Истина;
		ТекущийТипОтображения = 2;
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиКБудущимЗадачам" Тогда
		ПоказыватьБудущие = Истина;
		ПоказыватьЗавершенные = Ложь;
		ТекущийТипОтображения = 1;
	Иначе
		Возврат;
	КонецЕсли;
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "ЭтоБудущаяЗадача", ПоказыватьБудущие, Истина);
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "СобытиеЗавершено", ПоказыватьЗавершенные, Истина);
	
	Элементы.СписокЗадачОсталосьДней.Видимость = Ложь;
	
	Если ЗапуститьОбновлениеДанныхНаСервере() Тогда
		
		ЖдатьЗавершенияФоновогоЗадания();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма, Организация, Знач Задача)
	
	Элементы = Форма.Элементы;
	
	Если Не ЗначениеЗаполнено(Организация) И Не ЗначениеЗаполнено(Задача) Тогда
		Элементы.СтраницаКалендарьОтчетности.Видимость = Истина;
		Элементы.СтраницаВсеЗадачиЗавершены.Видимость = Ложь;
		Элементы.СтраницаЗадачаНеприменима.Видимость = Ложь;
	Иначе
		Если РегламентированнаяОтчетностьУСН.УстановитьПрименимостьЗадачиПоОрганизации(Организация, Задача) Тогда
			Если Форма.СписокЗадачПустой Тогда
				Элементы.СтраницаКалендарьОтчетности.Видимость = Ложь;
				Элементы.СтраницаВсеЗадачиЗавершены.Видимость = Истина;
				Элементы.СтраницаЗадачаНеприменима.Видимость = Ложь;
			Иначе
				Элементы.СтраницаКалендарьОтчетности.Видимость = Истина;
				Элементы.СтраницаВсеЗадачиЗавершены.Видимость = Ложь;
				Элементы.СтраницаЗадачаНеприменима.Видимость = Ложь;
			КонецЕсли;
		Иначе
			Элементы.СтраницаКалендарьОтчетности.Видимость = Ложь;
			Элементы.СтраницаВсеЗадачиЗавершены.Видимость = Ложь;
			Элементы.СтраницаЗадачаНеприменима.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// СписокЗадачОрганизация

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента 		= ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных("СписокЗадачОрганизация");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Организация", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.Организации.ПустаяСсылка());

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

КонецПроцедуры

&НаСервере
Функция НастройкиОформленияСпискаЗадач()
	
	НастройкиКомпоновкиДанных = Новый НастройкиКомпоновкиДанных;
	
	ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных,
		Неопределено, -1, НСтр("ru = 'Просрочено'"), ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных,
		0, 0, НСтр("ru = 'Сегодня'"), ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных,
		1, 1, НСтр("ru = 'Завтра'"));
	
	Шаблон = НСтр("ru = 'Осталось %1'");
	
	Для РазностьДат = 2 По 6 Цикл
		СтрокаРазностьДат = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
			РазностьДат, НСтр("ru = 'день,дня,дней'"));
		ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных,
			РазностьДат, РазностьДат, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, СтрокаРазностьДат));
	КонецЦикла;
	
	ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных,
		7, 13, НСтр("ru = 'Осталась неделя'"));
	
	ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных,
		14, 18, НСтр("ru = 'Осталось 2 недели'"));
	
	ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных,
		19, 22, НСтр("ru = 'Осталось 3 недели'"));
	
	ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных,
		23, 34, НСтр("ru = 'Остался месяц'"));
	
	// Используем пробел в качестве представления пустой строки, т.к. пустая строка в условном оформлении игнорируется
	ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных,
		35, Неопределено, " ");
		
	
	// Добавляем оформление для случая, когда отчет не сдан.
	ЭлементУсловногоОформления = НастройкиКомпоновкиДанных.УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отчет не сдан'"));
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Состояние");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Перечисления.СостоянияСобытийКалендаря.ОтчетНеСдан;
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных("ОсталосьДней");
	
	// Добавляем оформление для случая, когда отчет сдан в налоговой.
	ЭлементУсловногоОформления = НастройкиКомпоновкиДанных.УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветУспешнойОтправкиБРО);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отчет сдан!'"));
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Состояние");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Перечисления.СостоянияСобытийКалендаря.Завершить;
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных("ОсталосьДней");
	
	Возврат НастройкиКомпоновкиДанных;
	
КонецФункции

&НаСервере
Процедура ДобавитьЭлементУсловногоОформленияСпискаЗадач(НастройкиКомпоновкиДанных, НижняяГраница, ВерхняяГраница, Текст, ЦветТекста = Неопределено)
	
	ПутьКДаннымПоля = "ОсталосьДней";
	
	ЭлементУсловногоОформления = НастройкиКомпоновкиДанных.УсловноеОформление.Элементы.Добавить();
	
	Если ЦветТекста <> Неопределено Тогда
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
	КонецЕсли;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", Текст);
	
	Если НижняяГраница = Неопределено Тогда
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьКДаннымПоля);
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		ЭлементОтбора.ПравоеЗначение = ВерхняяГраница;
		
	ИначеЕсли ВерхняяГраница = Неопределено Тогда
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьКДаннымПоля);
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ЭлементОтбора.ПравоеЗначение = НижняяГраница;
		
	ИначеЕсли НижняяГраница = ВерхняяГраница Тогда
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьКДаннымПоля);
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = НижняяГраница;
		
	Иначе
		
		ГруппаЭлементовОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаЭлементовОтбора.Использование = Истина;
		ГруппаЭлементовОтбора.ТипГруппы     = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		
		ЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьКДаннымПоля);
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ЭлементОтбора.ПравоеЗначение = НижняяГраница;
		
		ЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьКДаннымПоля);
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		ЭлементОтбора.ПравоеЗначение = ВерхняяГраница;
		
	КонецЕсли;
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных(ПутьКДаннымПоля);
	
КонецПроцедуры

&НаСервере
// Запускает фоновое задание обновления Задач отчетности.
//
Функция ЗапуститьОбновлениеДанныхНаСервере()
	
	Если МонопольныйРежим() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ФоновоеЗаданиеЗадачЗапущено Тогда
		// Надо ждать
		Возврат Истина;
	КонецЕсли;
	
	ПараметрыФункции = Новый Структура();
	ПараметрыФункции.Вставить("Организация", Неопределено);
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"КалендарьОтчетности.ЗаполнитьВФоне", 
		ПараметрыФункции, 
		НСтр("ru = 'Обновление списка задач отчетности'"));
	
	ФоновоеЗаданиеЗадачИдентификатор   = Результат.ИдентификаторЗадания;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗаполнитьСписокЗадачНаСервереЗавершение();
	Иначе
		// Начнем ждать
		ФоновоеЗаданиеЗадачЗапущено = Истина;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции


&НаСервере
Процедура ЗаполнитьСписокЗадачНаСервереЗавершение()
	
	Элементы.СписокЗадач.Обновить();
	СписокЗадачПустой = СписокЗадачПустой(Организация, ПоказыватьЗавершенные, ПоказыватьБудущие, Задача);
	УправлениеФормой(ЭтаФорма, Организация, Задача);
	
КонецПроцедуры


&НаКлиенте
Процедура ЖдатьЗавершенияФоновогоЗадания()
	
	Если ФоновоеЗаданиеЗадачЗапущено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеДлительнойОперации",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеДлительнойОперации()
	
	Если ФоновоеЗаданиеЗадачЗапущено Тогда
		
		Если ЗаданиеВыполнено(ФоновоеЗаданиеЗадачИдентификатор) Тогда
			
			ФоновоеЗаданиеЗадачЗапущено = Ложь;
			ОповеститьОбИзменении(Тип("СправочникСсылка.ЗаписиКалендаряПодготовкиОтчетности"));
			СписокЗадачПустой = СписокЗадачПустой(Организация, ПоказыватьЗавершенные, ПоказыватьБудущие, Задача);
			
		КонецЕсли;
		
	КонецЕсли;
	
	
	Если ФоновоеЗаданиеЗадачЗапущено  Тогда
		// Продолжим ожидание
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания(
			"Подключаемый_ПроверитьЗавершениеДлительнойОперации",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал,
			Истина);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект, Организация, Задача);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ПеренестиЗадачуВАрхивСервер(Организация, СобытиеКалендаря)
	
	Ссылка = Справочники.ЗаписиКалендаряПодготовкиОтчетности.ПолучитьЗаписьКалендаря(Организация, СобытиеКалендаря);
	Если Ссылка <> Неопределено Тогда
		Запись = Ссылка.ПолучитьОбъект();
		Запись.Завершено = Истина;
		Запись.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокЗадачПустой(Знач Организация, ПоказыватьЗавершенные, ПоказыватьБудущие, Задача)
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря 
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО (Организации.Ссылка = ЗаписиКалендаряПодготовкиОтчетности.Организация)
	|			И (НЕ Организации.ПометкаУдаления)
	|			И (Организации.ИспользуетсяОтчетность)
	|			И (НЕ ЗаписиКалендаряПодготовкиОтчетности.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КалендарьПодготовкиОтчетности КАК КалендарьПодготовкиОтчетности
	|		ПО ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря = КалендарьПодготовкиОтчетности.Ссылка
	|			И (НЕ КалендарьПодготовкиОтчетности.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КалендарьПерсональныхЗадачОтчетности КАК КалендарьПерсональныхЗадачОтчетности
	|		ПО ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря = КалендарьПерсональныхЗадачОтчетности.Ссылка
	|			И (НЕ КалендарьПерсональныхЗадачОтчетности.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константа.ДатаПервогоВходаВСистему КАК ДатаПервогоВходаВСистему
	|		ПО (ИСТИНА)
	|";
	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	ДопУсловие = "";
	Если ЗначениеЗаполнено(Организация) Тогда
		ДопУсловие = ДопУсловие +"
		|	И Организации.Ссылка = &Организация";
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Если Не ПоказыватьЗавершенные Тогда
		ДопУсловие = ДопУсловие + "
		|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.Завершено
		|	И (ЕСТЬNULL(КалендарьПодготовкиОтчетности.ДатаОкончанияСобытия, КалендарьПерсональныхЗадачОтчетности.ДатаОкончанияСобытия) >= ДатаПервогоВходаВСистему.Значение
		|		ИЛИ ЗаписиКалендаряПодготовкиОтчетности.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияСобытийКалендаря.НеНачато))";
	КонецЕсли;
	
	Если Не ПоказыватьБудущие Тогда
		ДопУсловие = ДопУсловие + "
		|	И (ЕСТЬNULL(КалендарьПодготовкиОтчетности.ДатаНачалаИнформирования, КалендарьПерсональныхЗадачОтчетности.ДатаНачалаИнформирования) <= &ТекущаяДата
		|	ИЛИ ЗаписиКалендаряПодготовкиОтчетности.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияСобытийКалендаря.НеНачато))";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Задача) Тогда
		ДопУсловие = ДопУсловие + "
			|	И ЕСТЬNULL(КалендарьПодготовкиОтчетности.Задача,КалендарьПерсональныхЗадачОтчетности.Задача) = &Задача";
		Запрос.УстановитьПараметр("Задача", Задача);
	КонецЕсли;
		
	ТекстЗапроса = ТекстЗапроса + ?(ПустаяСтрока(ДопУсловие),"","ГДЕ ИСТИНА "+ДопУсловие);
	
	Запрос.Текст = ТекстЗапроса;
	
	СписокЗадачПустой = Запрос.Выполнить().Пустой();
	
	Возврат СписокЗадачПустой;
	
КонецФункции

&НаКлиенте
Процедура СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элемент.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		СтруктураСобытия = Новый Структура("СобытиеКалендаря, СостояниеСобытия, Организация",
			ТекДанные.СобытиеКалендаря,
			ТекДанные.Состояние,
			ТекДанные.Организация);
		ИмяФормыЗадачи = ПолучитьИмяФормыПоЗадачеИСостоянию(ТекДанные.Задача, ТекДанные.Состояние);
		Если Не ПустаяСтрока(ИмяФормыЗадачи) Тогда
			ОткрытьФорму(ИмяФормыЗадачи, СтруктураСобытия);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИмяФормыПоЗадачеИСостоянию(Задача, Состояние)
	Возврат Справочники.ЗаписиКалендаряПодготовкиОтчетности.ПолучитьИмяФормыПоЗадачеИСостоянию(Задача, Состояние);
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеСостоянияСобытияКалендаря" Тогда
		Элементы.СписокЗадач.Обновить();
	ИначеЕсли ИмяСобытия = "Запись_Организации" И Параметр = Организация Тогда
		УправлениеФормой(ЭтаФорма, Организация,Задача);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущийТипОтображенияПриИзменении(Элемент)
	Если ТекущийТипОтображения = 1 Тогда
		// Будущие
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "ЭтоБудущаяЗадача", Истина, Истина);
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "СобытиеЗавершено", Ложь, Истина);
		ПоказыватьБудущие = Истина;
		ПоказыватьЗавершенные = Ложь;
		Элементы.СписокЗадачОсталосьДней.Видимость = Истина;
	ИначеЕсли ТекущийТипОтображения = 2 Тогда
		// Архив
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "ЭтоБудущаяЗадача", Ложь, Истина);
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "СобытиеЗавершено", Истина, Истина);
		ПоказыватьБудущие = Ложь;
		ПоказыватьЗавершенные = Истина;
		Элементы.СписокЗадачОсталосьДней.Видимость = Ложь;
	Иначе
		// Текущие
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "ЭтоБудущаяЗадача", Ложь, Истина);
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(СписокЗадач, "СобытиеЗавершено", Ложь, Истина);
		ПоказыватьБудущие = Ложь;
		ПоказыватьЗавершенные = Ложь;
		Элементы.СписокЗадачОсталосьДней.Видимость = Истина;
	КонецЕсли;
	
	Если ЗапуститьОбновлениеДанныхНаСервере() Тогда
		ЖдатьЗавершенияФоновогоЗадания();
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти
