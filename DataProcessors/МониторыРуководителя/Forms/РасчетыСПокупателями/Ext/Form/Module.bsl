﻿
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьНастройки();
	ОбновитьДанные();
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовФормы

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
Процедура ОрганизацияПриИзменении(Элемент)

	ОбновитьДанные();
	
КонецПроцедуры // ОрганизацияПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Период.
//
Процедура ПериодПриИзменении(Элемент)
	
	Если Период = '00010101' Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	ОбновитьДанные();
	
КонецПроцедуры

// Процедура - обработчик события Нажатие гиперссылки Подробнее из виджета Дебиторы.
//
&НаКлиенте
Процедура ДебиторыПодробнееНажатие(Элемент)
	
	СвойстваОтчета = Новый Структура;
	СвойстваОтчета.Вставить("ИмяОтчета", "РасчетыСПокупателями");
	СвойстваОтчета.Вставить("КлючВарианта", "Ведомость");
	
	ПараметрыИОтборы = Новый Массив;
	
	Настройка = Новый Структура;
	Настройка.Вставить("ИмяПоля", "Организация");
	Настройка.Вставить("ПравоеЗначение", Организация);
	ПараметрыИОтборы.Добавить(Настройка);
	
	Настройка = Новый Структура;
	Настройка.Вставить("ИмяПоля", "НачалоПериода");
	Настройка.Вставить("ПравоеЗначение", ДобавитьМесяц(НачалоДня(Период),-1));
	ПараметрыИОтборы.Добавить(Настройка);
	
	Настройка = Новый Структура;
	Настройка.Вставить("ИмяПоля", "КонецПериода");
	Настройка.Вставить("ПравоеЗначение", КонецДня(Период));
	ПараметрыИОтборы.Добавить(Настройка);
	
	КомпоновщикНастроек = УправлениеНебольшойФирмойСервер.ПолучитьПереопределенныйКомпоновщикНастроек(СвойстваОтчета, ПараметрыИОтборы);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта",		 		 СвойстваОтчета.КлючВарианта);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",	 Истина);
	
	ОткрытьФорму("Отчет." + СвойстваОтчета.ИмяОтчета + ".Форма", ПараметрыФормы, Элемент, УникальныйИдентификатор);
	
КонецПроцедуры

// Процедура - обработчик события Нажатие гиперссылки Подробнее из виджета ДебиторыПоСрокам.
//
&НаКлиенте
Процедура ДебиторыПоСрокамПодробнееНажатие(Элемент)
	
	СвойстваОтчета = Новый Структура;
	СвойстваОтчета.Вставить("ИмяОтчета", "РеестрСтаренияДебиторскойЗадолженности");
	СвойстваОтчета.Вставить("КлючВарианта", "Ведомость");
	
	ПараметрыИОтборы = Новый Массив;
	
	Настройка = Новый Структура;
	Настройка.Вставить("ИмяПоля", "Организация");
	Настройка.Вставить("ПравоеЗначение", Организация);
	ПараметрыИОтборы.Добавить(Настройка);
	
	Настройка = Новый Структура;
	Настройка.Вставить("ИмяПоля", "ПериодПольз");
	Настройка.Вставить("ПравоеЗначение", КонецДня(Период));
	ПараметрыИОтборы.Добавить(Настройка);
	
	КомпоновщикНастроек = УправлениеНебольшойФирмойСервер.ПолучитьПереопределенныйКомпоновщикНастроек(СвойстваОтчета, ПараметрыИОтборы);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта",		 		 СвойстваОтчета.КлючВарианта);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",	 Истина);
	
	ОткрытьФорму("Отчет." + СвойстваОтчета.ИмяОтчета + ".Форма", ПараметрыФормы, Элемент, УникальныйИдентификатор);
	
КонецПроцедуры

// Процедура - обработчик события Нажатие гиперссылки Подробнее из виджета ДебиторыПросрочено.
//
&НаКлиенте
Процедура ДебиторыПросроченоПодробнееНажатие(Элемент)
	
	СвойстваОтчета = Новый Структура;
	СвойстваОтчета.Вставить("ИмяОтчета", "РеестрСтаренияДебиторскойЗадолженности");
	СвойстваОтчета.Вставить("КлючВарианта", "Ведомость");
	
	ПараметрыИОтборы = Новый Массив;
	
	Настройка = Новый Структура;
	Настройка.Вставить("ИмяПоля", "Организация");
	Настройка.Вставить("ПравоеЗначение", Организация);
	ПараметрыИОтборы.Добавить(Настройка);
	
	Настройка = Новый Структура;
	Настройка.Вставить("ИмяПоля", "ПериодПольз");
	Настройка.Вставить("ПравоеЗначение", КонецДня(Период));
	ПараметрыИОтборы.Добавить(Настройка);
	
	Настройка = Новый Структура;
	Настройка.Вставить("ИмяПоля", "ДПросроченнаяЗадолженность");
	Настройка.Вставить("ПравоеЗначение", 0);
	Настройка.Вставить("ВидСравнения", ВидСравненияКомпоновкиДанных.Больше);
	Настройка.Вставить("ВидНастройки", "ФиксированныеНастройки");
	ПараметрыИОтборы.Добавить(Настройка);
	
	КомпоновщикНастроек = УправлениеНебольшойФирмойСервер.ПолучитьПереопределенныйКомпоновщикНастроек(СвойстваОтчета, ПараметрыИОтборы);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта",		 		 СвойстваОтчета.КлючВарианта);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыФормы.Вставить("ФиксированныеНастройки",	 КомпоновщикНастроек.ФиксированныеНастройки);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",	 Истина);
	
	ОткрытьФорму("Отчет." + СвойстваОтчета.ИмяОтчета + ".Форма", ПараметрыФормы, Элемент, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДанные();
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
// Процедура восстанавливает настройки общие для мониторов.
//
Процедура ПолучитьНастройки()
	
	Если Константы.УчетПоКомпании.Получить() Тогда
		Организация = Константы.Компания.Получить();
		Элементы.Организация.ТолькоПросмотр = Истина;
	Иначе
		Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиДляМониторов", "Организация");
		Если НЕ ЗначениеЗаполнено(Организация) Тогда
			Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
			Если НЕ ЗначениеЗаполнено(Организация) Тогда
				Организация = Справочники.Организации.ОсновнаяОрганизация;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Период = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиДляМониторов", "Период");
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры // ПолучитьНастройки()

&НаСервере
// Процедура сохраняет настройки общие для мониторов.
//
Процедура СохранитьНастройки()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиДляМониторов", "Организация", Организация);
	
	Если (НачалоДня(ТекущаяДатаСеанса()) = НачалоДня(Период)) Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиДляМониторов", "Период", '00010101');
	Иначе
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиДляМониторов", "Период", Период);
	КонецЕсли;

КонецПроцедуры // СохранитьНастройки()

&НаСервере
// Процедура обновляет данные на форме.
//
Процедура ОбновитьДанные()
	
	ПредставлениеПериода = Формат(ДобавитьМесяц(Период, -1), "ДЛФ=DD") + " — " + Формат(Период, "ДЛФ=DD") + ?(НачалоДня(Период) = НачалоДня(ТекущаяДатаСеанса()), " (Сегодня)", "");
	
	ОбновитьДиаграммуДебиторы();
	ОбновитьДиаграммуИВиджетДебиторыПоСрокам();
	ОбновитьДиаграммуДинамикаЗадолженности();
	ОбновитьВиджетДебиторы();
	ОбновитьВиджетПросроченно();
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДиаграммуДебиторы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасчетыСПокупателямиОстатки.Контрагент,
		|	РасчетыСПокупателямиОстатки.Контрагент.Представление,
		|	РасчетыСПокупателямиОстатки.СуммаОстаток КАК Долг
		|ИЗ
		|	РегистрНакопления.РасчетыСПокупателями.Остатки(
		|			&Период,
		|			Организация = &Организация
		|				И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПокупателямиОстатки
		|
		|УПОРЯДОЧИТЬ ПО
		|	Долг УБЫВ";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", КонецДня(Период));
	
	ДиаграммаДебиторы.Обновление = Ложь;
	ДиаграммаДебиторы.Очистить();
	ДиаграммаДебиторы.АвтоТранспонирование = Ложь;
	ДиаграммаДебиторы.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки, -1);
	
	Точка = ДиаграммаДебиторы.Точки.Добавить("Долг = ");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Серия = ДиаграммаДебиторы.Серии.Добавить(Выборка.КонтрагентПредставление);
		Серия.Расшифровка = Выборка.Контрагент;
		Подсказка = "Задолженность " + Выборка.КонтрагентПредставление + " " + Выборка.Долг;
		ДиаграммаДебиторы.УстановитьЗначение(Точка, Серия, Выборка.Долг, , Подсказка);
		
	КонецЦикла;

	ДиаграммаДебиторы.АвтоТранспонирование = Истина;
	ДиаграммаДебиторы.Обновление = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДиаграммуИВиджетДебиторыПоСрокам()
	
	ШиринаКонтрагент  = 25;
	ШиринаМенее7 = 9;
	ШиринаМенее30 = 9;
	ШиринаБолее31 = 9;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РасчетыСПокупателямиОстатки.Контрагент КАК Контрагент,
		|	РасчетыСПокупателямиОстатки.Контрагент.Представление,
		|	СУММА(ВЫБОР
		|			КОГДА РАЗНОСТЬДАТ(РасчетыСПокупателямиОстатки.Документ.Дата, &Период, ДЕНЬ) <= 7
		|					И РАЗНОСТЬДАТ(РасчетыСПокупателямиОстатки.Документ.Дата, &Период, ДЕНЬ) >= 0
		|				ТОГДА РасчетыСПокупателямиОстатки.СуммаОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ДолгМенее7,
		|	СУММА(ВЫБОР
		|			КОГДА РАЗНОСТЬДАТ(РасчетыСПокупателямиОстатки.Документ.Дата, &Период, ДЕНЬ) >= 8
		|					И РАЗНОСТЬДАТ(РасчетыСПокупателямиОстатки.Документ.Дата, &Период, ДЕНЬ) <= 30
		|				ТОГДА РасчетыСПокупателямиОстатки.СуммаОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ДолгМенее30,
		|	СУММА(ВЫБОР
		|			КОГДА РАЗНОСТЬДАТ(РасчетыСПокупателямиОстатки.Документ.Дата, &Период, ДЕНЬ) >= 31
		|				ТОГДА РасчетыСПокупателямиОстатки.СуммаОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ДолгБолее31
		|ИЗ
		|	РегистрНакопления.РасчетыСПокупателями.Остатки(
		|			&Период,
		|			Организация = &Организация
		|				И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПокупателямиОстатки
		|ГДЕ
		|	РасчетыСПокупателямиОстатки.СуммаОстаток > 0
		|	И РАЗНОСТЬДАТ(РасчетыСПокупателямиОстатки.Документ.Дата, &Период, ДЕНЬ) >= 0
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетыСПокупателямиОстатки.Контрагент,
		|	РасчетыСПокупателямиОстатки.Контрагент.Представление
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДолгБолее31 УБЫВ,
		|	ДолгМенее30 УБЫВ,
		|	ДолгМенее7 УБЫВ
		|ИТОГИ ПО
		|	ОБЩИЕ";
		
	Запрос.УстановитьПараметр("Период", КонецДня(Период));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Элементы.ДекорацияДебиторыМенее7Итог.Заголовок = "";
	Элементы.ДекорацияДебиторыМенее30Итог.Заголовок = "";
	Элементы.ДекорацияДебиторыБолее31Итог.Заголовок = "";
	
	ДиаграммаДебиторыПоСрокам.Обновление = Ложь;
	ДиаграммаДебиторыПоСрокам.Очистить();
	ДиаграммаДебиторыПоСрокам.АвтоТранспонирование = Ложь;
	ДиаграммаДебиторыПоСрокам.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки, -1);
	
	Точка = ДиаграммаДебиторыПоСрокам.Точки.Добавить("Долг = ");
	
	ДолгМенее7 = "до 7 дней";
	ДолгМенее30 = "8 - 30 дней";
	ДолгБолее31 = "от 31 дня";
	
	Элементы.КонтрагентыПоСрокам.Заголовок = "";
	Элементы.КонтрагентыПоСрокам.Подсказка = "";
	Элементы.ДебиторыМенее7.Заголовок = "";
	Элементы.ДебиторыМенее7.Подсказка = "";
	Элементы.ДебиторыМенее30.Заголовок = "";
	Элементы.ДебиторыМенее30.Подсказка = "";
	Элементы.ДебиторыБолее31.Заголовок = "";
	Элементы.ДебиторыБолее31.Подсказка = "";
	
	ВыборкаОбщийИтог = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если ВыборкаОбщийИтог.Следующий() Тогда
		
		Элементы.ДекорацияДебиторыМенее7Итог.Заголовок = УправлениеНебольшойФирмойСервер.СформироватьЗаголовок(ВыборкаОбщийИтог.ДолгМенее7);
		Элементы.ДекорацияДебиторыМенее30Итог.Заголовок = УправлениеНебольшойФирмойСервер.СформироватьЗаголовок(ВыборкаОбщийИтог.ДолгМенее30);
		Элементы.ДекорацияДебиторыБолее31Итог.Заголовок = УправлениеНебольшойФирмойСервер.СформироватьЗаголовок(ВыборкаОбщийИтог.ДолгБолее31);
		
		Серия = ДиаграммаДебиторыПоСрокам.Серии.Добавить(ДолгМенее7);
		Серия.Цвет = УправлениеНебольшойФирмойСервер.ЦветДляМониторов("Зеленый");
		Подсказка = "Просрочено менее 7 дней " + ВыборкаОбщийИтог.ДолгМенее7;
		ДиаграммаДебиторыПоСрокам.УстановитьЗначение(Точка, Серия, ВыборкаОбщийИтог.ДолгМенее7, , Подсказка);
		
		Серия = ДиаграммаДебиторыПоСрокам.Серии.Добавить(ДолгМенее30);
		Серия.Цвет = УправлениеНебольшойФирмойСервер.ЦветДляМониторов("Желтый");
		Подсказка = "Просрочено от 8 до 30 дней " + ВыборкаОбщийИтог.ДолгМенее30;
		ДиаграммаДебиторыПоСрокам.УстановитьЗначение(Точка, Серия, ВыборкаОбщийИтог.ДолгМенее30, , Подсказка);
		
		Серия = ДиаграммаДебиторыПоСрокам.Серии.Добавить(ДолгБолее31);
		Серия.Цвет = УправлениеНебольшойФирмойСервер.ЦветДляМониторов("Красный");
		Подсказка = "Просрочено более 31 дней " + ВыборкаОбщийИтог.ДолгБолее31;
		ДиаграммаДебиторыПоСрокам.УстановитьЗначение(Точка, Серия, ВыборкаОбщийИтог.ДолгБолее31, , Подсказка);
		
		Выборка = ВыборкаОбщийИтог.Выбрать();
		
		Для Индекс = 1 По 6 Цикл
			
			Если Выборка.Следующий() Тогда
				
				ДолгМенее7Представление = Формат(Выборка.ДолгМенее7, "ЧДЦ=2; ЧРГ=' '; ЧН=0,00; ЧГ=3,0");
				ДолгМенее30Представление = Формат(Выборка.ДолгМенее30, "ЧДЦ=2; ЧРГ=' '; ЧН=0,00; ЧГ=3,0");
				ДолгБолее31Представление = Формат(Выборка.ДолгБолее31, "ЧДЦ=2; ЧРГ=' '; ЧН=0,00; ЧГ=3,0");
				
				ЗаголовокКонтрагент = СтрЗаменить(Выборка.КонтрагентПредставление, " ", Символы.НПП);
				Элементы.КонтрагентыПоСрокам.Заголовок = Элементы.КонтрагентыПоСрокам.Заголовок + ?(ПустаяСтрока(Элементы.КонтрагентыПоСрокам.Заголовок),"", Символы.ПС) 
					+ Лев(ЗаголовокКонтрагент, ШиринаКонтрагент) + ?(СтрДлина(ЗаголовокКонтрагент) > ШиринаКонтрагент, "...", "");
				Элементы.КонтрагентыПоСрокам.Подсказка = Элементы.КонтрагентыПоСрокам.Подсказка + ?(ПустаяСтрока(Элементы.КонтрагентыПоСрокам.Подсказка),"", Символы.ПС) 
					+ ЗаголовокКонтрагент;
				
				Элементы.ДебиторыМенее7.Заголовок = Элементы.ДебиторыМенее7.Заголовок + ?(ПустаяСтрока(Элементы.ДебиторыМенее7.Заголовок),"", Символы.ПС) 
					+ Лев(ДолгМенее7Представление, ШиринаМенее7) + ?(СтрДлина(ДолгМенее7Представление) > ШиринаМенее7, "...", "");
				Элементы.ДебиторыМенее7.Подсказка = Элементы.ДебиторыМенее7.Подсказка + ?(ПустаяСтрока(Элементы.ДебиторыМенее7.Подсказка),"", Символы.ПС) 
					+ ДолгМенее7Представление;
				
				Элементы.ДебиторыМенее30.Заголовок = Элементы.ДебиторыМенее30.Заголовок + ?(ПустаяСтрока(Элементы.ДебиторыМенее30.Заголовок),"", Символы.ПС) 
					+ Лев(ДолгМенее30Представление, ШиринаМенее30) + ?(СтрДлина(ДолгМенее30Представление) > ШиринаМенее30, "...", "");
				Элементы.ДебиторыМенее30.Подсказка = Элементы.ДебиторыМенее30.Подсказка + ?(ПустаяСтрока(Элементы.ДебиторыМенее30.Подсказка),"", Символы.ПС) 
					+ ДолгМенее30Представление;
				
				Элементы.ДебиторыБолее31.Заголовок = Элементы.ДебиторыБолее31.Заголовок + ?(ПустаяСтрока(Элементы.ДебиторыБолее31.Заголовок),"", Символы.ПС) 
					+ Лев(ДолгБолее31Представление, ШиринаБолее31) + ?(СтрДлина(ДолгБолее31Представление) > ШиринаБолее31, "...", "");
				Элементы.ДебиторыБолее31.Подсказка = Элементы.ДебиторыБолее31.Подсказка + ?(ПустаяСтрока(Элементы.ДебиторыБолее31.Подсказка),"", Символы.ПС) 
					+ ДолгБолее31Представление;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Элементы.ДекорацияДебиторыМенее7Итог.Заголовок = "—";
		Элементы.ДекорацияДебиторыМенее30Итог.Заголовок = "—";
		Элементы.ДекорацияДебиторыБолее31Итог.Заголовок = "—";
		
	КонецЕсли;
		
	ДиаграммаДебиторыПоСрокам.АвтоТранспонирование = Истина;
	ДиаграммаДебиторыПоСрокам.Обновление = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДиаграммуДинамикаЗадолженности()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РасчетыСПокупателямиОстаткиИОбороты.Период КАК Период,
		|	РасчетыСПокупателямиОстаткиИОбороты.СуммаКонечныйОстаток КАК СуммаКонечныйОстаток
		|ИЗ
		|	РегистрНакопления.РасчетыСПокупателями.ОстаткиИОбороты(
		|			&ДатаОтбораНачала,
		|			&ДатаОтбораОкончания,
		|			День,
		|			ДвиженияИГраницыПериода,
		|			Организация = &Организация
		|				И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПокупателямиОстаткиИОбороты
		|ГДЕ
		|	РасчетыСПокупателямиОстаткиИОбороты.СуммаКонечныйОстаток > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период
		|ИТОГИ
		|	СУММА(СуммаКонечныйОстаток)
		|ПО
		|	Период ПЕРИОДАМИ(ДЕНЬ, &ДатаОтбораНачала, &ДатаОтбораОкончания)";

	Запрос.УстановитьПараметр("ДатаОтбораНачала", ДобавитьМесяц(НачалоДня(Период),-1));
	Запрос.УстановитьПараметр("ДатаОтбораОкончания", КонецДня(Период));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	ДиаграммаДинамикаЗадолженности.Обновление = Ложь;
	ДиаграммаДинамикаЗадолженности.Очистить();
	ДиаграммаДинамикаЗадолженности.АвтоТранспонирование = Ложь;
	ДиаграммаДинамикаЗадолженности.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки, -1);

	Серия = ДиаграммаДинамикаЗадолженности.Серии.Добавить("Период");
	Серия.Линия = Новый Линия(ТипЛинииДиаграммы.Сплошная, 2);
	Серия.Маркер = ТипМаркераДиаграммы.Нет;
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Период", "Все");
	
	Пока Выборка.Следующий() Цикл
		
		Точка = ДиаграммаДинамикаЗадолженности.Точки.Добавить(Выборка.Период);
		Точка.Текст = Формат(Выборка.Период, "ДФ=dd.MM.yy");
		Подсказка = "Долг " + Выборка.СуммаКонечныйОстаток + " на " + Формат(Выборка.Период, "ДФ=dd.MM.yyyy");
		ДиаграммаДинамикаЗадолженности.УстановитьЗначение(Точка, Серия, Выборка.СуммаКонечныйОстаток, , Подсказка);
		 
	КонецЦикла;	
	
	ДиаграммаДинамикаЗадолженности.АвтоТранспонирование = Истина;
	ДиаграммаДинамикаЗадолженности.Обновление = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВиджетДебиторы()
	
	ШиринаКонтрагент  = 28;
	ШиринаДолг = 10;
	ШиринаАванс = 10;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РасчетыСПокупателямиОстатки.Контрагент КАК Контрагент,
		|	РасчетыСПокупателямиОстатки.Контрагент.Представление,
		|	СУММА(ВЫБОР
		|			КОГДА РасчетыСПокупателямиОстатки.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)
		|				ТОГДА РасчетыСПокупателямиОстатки.СуммаОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаДолга,
		|	СУММА(ВЫБОР
		|			КОГДА РасчетыСПокупателямиОстатки.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)
		|				ТОГДА -РасчетыСПокупателямиОстатки.СуммаОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаАванса
		|ИЗ
		|	РегистрНакопления.РасчетыСПокупателями.Остатки(&ДатаОтбора, Организация = &Организация) КАК РасчетыСПокупателямиОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетыСПокупателямиОстатки.Контрагент,
		|	РасчетыСПокупателямиОстатки.Контрагент.Представление
		|
		|УПОРЯДОЧИТЬ ПО
		|	СуммаДолга УБЫВ
		|ИТОГИ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Контрагент),
		|	СУММА(СуммаДолга),
		|	СУММА(СуммаАванса)
		|ПО
		|	ОБЩИЕ";

	Запрос.УстановитьПараметр("ДатаОтбора", КонецДня(Период));
	Запрос.УстановитьПараметр("ДатаОтбораНачала", ДобавитьМесяц(НачалоДня(Период),-1));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	ВыборкаОбщиеИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаОбщиеИтоги.Следующий() Тогда
		Элементы.ДекорацияДебиторыКоличество.Заголовок = ВыборкаОбщиеИтоги.Контрагент;
		Элементы.ДекорацияДебиторыЗадолженностьИтог.Заголовок = УправлениеНебольшойФирмойСервер.СформироватьЗаголовок(ВыборкаОбщиеИтоги.СуммаДолга);
		Элементы.ДекорацияДебиторыАвансИтог.Заголовок = УправлениеНебольшойФирмойСервер.СформироватьЗаголовок(ВыборкаОбщиеИтоги.СуммаАванса);
	Иначе
		Элементы.ДекорацияДебиторыКоличество.Заголовок = "—";
		Элементы.ДекорацияДебиторыЗадолженностьИтог.Заголовок = "—";
		Элементы.ДекорацияДебиторыАвансИтог.Заголовок = "—";
	КонецЕсли;
	
	Элементы.ДебиторыКонтрагент.Заголовок = "";
	Элементы.ДебиторыКонтрагент.Подсказка = "";
	Элементы.ДебиторыДолг.Заголовок = "";
	Элементы.ДебиторыДолг.Подсказка = "";
	Элементы.ДебиторыАванс.Заголовок = "";
	Элементы.ДебиторыАванс.Подсказка = "";
	
	Выборка = ВыборкаОбщиеИтоги.Выбрать();
	Для Индекс = 1 По 6 Цикл
		Если Выборка.Следующий() Тогда
			
			СуммаДолгаПредставление = Формат(Выборка.СуммаДолга, "ЧДЦ=2; ЧРГ=' '; ЧН=0,00; ЧГ=3,0");
			СуммаАвансаПредставление = Формат(Выборка.СуммаАванса, "ЧДЦ=2; ЧРГ=' '; ЧН=0,00; ЧГ=3,0");
			
			ЗаголовокКонтрагент = СтрЗаменить(Выборка.КонтрагентПредставление, " ", Символы.НПП);
			Элементы.ДебиторыКонтрагент.Заголовок = Элементы.ДебиторыКонтрагент.Заголовок + ?(ПустаяСтрока(Элементы.ДебиторыКонтрагент.Заголовок),"", Символы.ПС) 
				+ Лев(ЗаголовокКонтрагент, ШиринаКонтрагент) + ?(СтрДлина(ЗаголовокКонтрагент) > ШиринаКонтрагент, "...", "");
			Элементы.ДебиторыКонтрагент.Подсказка = Элементы.ДебиторыКонтрагент.Подсказка + ?(ПустаяСтрока(Элементы.ДебиторыКонтрагент.Подсказка),"", Символы.ПС) 
				+ ЗаголовокКонтрагент;
				
			Элементы.ДебиторыДолг.Заголовок = Элементы.ДебиторыДолг.Заголовок + ?(ПустаяСтрока(Элементы.ДебиторыДолг.Заголовок),"", Символы.ПС) 
				+ Лев(СуммаДолгаПредставление, ШиринаДолг) + ?(СтрДлина(СуммаДолгаПредставление) > ШиринаДолг, "...", "");
			Элементы.ДебиторыДолг.Подсказка = Элементы.ДебиторыДолг.Подсказка + ?(ПустаяСтрока(Элементы.ДебиторыДолг.Подсказка),"", Символы.ПС) 
				+ СуммаДолгаПредставление;
				
			Элементы.ДебиторыАванс.Заголовок = Элементы.ДебиторыАванс.Заголовок + ?(ПустаяСтрока(Элементы.ДебиторыАванс.Заголовок),"", Символы.ПС) 
				+ Лев(СуммаАвансаПредставление, ШиринаАванс) + ?(СтрДлина(СуммаАвансаПредставление) > ШиринаАванс, "...", "");
			Элементы.ДебиторыАванс.Подсказка = Элементы.ДебиторыАванс.Подсказка + ?(ПустаяСтрока(Элементы.ДебиторыАванс.Подсказка),"", Символы.ПС) 
				+ СуммаАвансаПредставление;
				
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВиджетПросроченно()
	
	ШиринаКонтрагент = 28;
	ШиринаПросрочено = 10;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РасчетыСПокупателямиОстатки.Контрагент КАК Контрагент,
		|	РасчетыСПокупателямиОстатки.Контрагент.Представление,
		|	РасчетыСПокупателямиОстатки.СуммаОстаток КАК СуммаПросрочено
		|ИЗ
		|	РегистрНакопления.РасчетыСПокупателями.Остатки(
		|			&ДатаОтбора,
		|			Организация = &Организация
		|				И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)
		|				И Договор.СрокОплатыПокупателя > 0
		|				И РАЗНОСТЬДАТ(Документ.Дата, &ДатаОтбора, ДЕНЬ) > Договор.СрокОплатыПокупателя) КАК РасчетыСПокупателямиОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетыСПокупателямиОстатки.Контрагент,
		|	РасчетыСПокупателямиОстатки.Контрагент.Представление,
		|	РасчетыСПокупателямиОстатки.СуммаОстаток
		|
		|УПОРЯДОЧИТЬ ПО
		|	СуммаПросрочено УБЫВ
		|ИТОГИ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Контрагент),
		|	СУММА(СуммаПросрочено)
		|ПО
		|	ОБЩИЕ";
	
	Запрос.УстановитьПараметр("ДатаОтбора", КонецДня(Период));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	ВыборкаОбщиеИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаОбщиеИтоги.Следующий() Тогда
		Элементы.ДекорацияДебиторыПросроченоКоличество.Заголовок = ВыборкаОбщиеИтоги.Контрагент;
		Элементы.ДекорацияДебиторыПросроченоИтог.Заголовок = УправлениеНебольшойФирмойСервер.СформироватьЗаголовок(ВыборкаОбщиеИтоги.СуммаПросрочено);
	Иначе
		Элементы.ДекорацияДебиторыПросроченоКоличество.Заголовок = "—";
		Элементы.ДекорацияДебиторыПросроченоИтог.Заголовок = "—";
	КонецЕсли;
	
	Элементы.ДебиторыПросроченоКонтрагент.Заголовок = "";
	Элементы.ДебиторыПросроченоКонтрагент.Подсказка = "";
	Элементы.ДебиторыПросрочено.Заголовок = "";
	Элементы.ДебиторыПросрочено.Подсказка = "";
	
	Выборка = ВыборкаОбщиеИтоги.Выбрать();
	Для Индекс = 1 По 6 Цикл
		Если Выборка.Следующий() Тогда
			
			СуммаПросроченоПредставление = Формат(Выборка.СуммаПросрочено, "ЧДЦ=2; ЧРГ=' '; ЧН=0,00; ЧГ=3,0");
			
			ЗаголовокКонтрагент = СтрЗаменить(Выборка.КонтрагентПредставление, " ", Символы.НПП);
			Элементы.ДебиторыПросроченоКонтрагент.Заголовок = Элементы.ДебиторыПросроченоКонтрагент.Заголовок + ?(ПустаяСтрока(Элементы.ДебиторыПросроченоКонтрагент.Заголовок),"", Символы.ПС) 
				+ Лев(ЗаголовокКонтрагент, ШиринаКонтрагент) + ?(СтрДлина(ЗаголовокКонтрагент) > ШиринаКонтрагент, "...", "");
			Элементы.ДебиторыПросроченоКонтрагент.Подсказка = Элементы.ДебиторыПросроченоКонтрагент.Подсказка + ?(ПустаяСтрока(Элементы.ДебиторыПросроченоКонтрагент.Подсказка),"", Символы.ПС) 
				+ ЗаголовокКонтрагент;
				
			Элементы.ДебиторыПросрочено.Заголовок = Элементы.ДебиторыПросрочено.Заголовок + ?(ПустаяСтрока(Элементы.ДебиторыПросрочено.Заголовок),"", Символы.ПС) 
				+ Лев(СуммаПросроченоПредставление, ШиринаПросрочено) + ?(СтрДлина(СуммаПросроченоПредставление) > ШиринаПросрочено, "...", "");
			Элементы.ДебиторыПросрочено.Подсказка = Элементы.ДебиторыПросрочено.Подсказка + ?(ПустаяСтрока(Элементы.ДебиторыПросрочено.Подсказка),"", Символы.ПС) 
				+ СуммаПросроченоПредставление;
				
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
