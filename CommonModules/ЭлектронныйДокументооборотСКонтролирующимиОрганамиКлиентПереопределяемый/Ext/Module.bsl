﻿// Открывает окно сотрудника, позиционируясь на элементе формы,
// значение которого нужно изменить.
//
// Параметры:
//  СправочникСсылка.ФизическиеЛица  - физическое лицо, форму которого необходимо открыть
//  НаименованиеРеквизита - Строка - параметр позволяет определить, какой на каком элементе формы физического лица
//		необходимо спозиционировать курсор. В самой функции каждому значению данного параметра определен соотвествующей элемент формы физического лица
//		Возможные варианты значений параметра:
//			СНИЛС
//          АдресРегистрации
//          Телефон
// СтандартнаяОбработка - Булево - если Истина, то переопределяемый метод будет проигнорирован.
//
Процедура ОткрытьФормуСотрудникаНаРеквизите(Сотрудник, НаименованиеРеквизита, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	// Определяем соотвествие имен реквизитов мастера и имен реквизитов формы организации
	СоответствиеИмен = Новый Структура(); 
	
	//СоответствиеИмен.Вставить(<имя поля мастера>, <Имя элемента управления формы владельца ЭЦП>)
	СоответствиеИмен.Вставить("СНИЛС", "ФизлицоСтраховойНомерПФР");
	
	ИмяРеквизитаФормы = "";
	СоответствиеИмен.Свойство(НаименованиеРеквизита,ИмяРеквизитаФормы);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", Сотрудник);
	
	Форма = ПолучитьФорму("Справочник.Сотрудники.Форма.ФормаЭлемента", ПараметрыФормы);
	Если Форма.Элементы.Найти(ИмяРеквизитаФормы)<> Неопределено Тогда 
		Форма.ТекущийЭлемент = Форма.Элементы[ИмяРеквизитаФормы];
	КонецЕсли;
	Форма.Открыть();
	
КонецПроцедуры

// Открывает список для выбора сотрудника.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - задает процедуру, которая будет вызвана после выбора.
//   Сотрудник - ОпределяемыйТип.СотрудникМакетПенсионногоДела - ссылка на сотрудника.
//   Организация - СправочникСсылка.Организация - организация, может использоваться для отбора.
//   ВладелецФормы - УправляемаяФорма - форма, которая будет установлена в качестве владельца списка.
//   СтандартнаяОбработка - Булево - Истина - используется стандартный способ выбора из справочника,
//                                   Ложь - выбор из списка переопределяется.
//
Процедура ВыбратьСотрудникаИзСписка(ОповещениеОЗавершении, Сотрудник, Организация, ВладелецФормы, СтандартнаяОбработка) Экспорт
			
КонецПроцедуры

// Открывает окно физического лица, позиционируясь элементе формы физического лица,
// значение которого нужно изменить из мастера подключения к 1С-Отчетности
//
//
// Параметры:
//  СправочникСсылка.ФизическиеЛица  - физическое лицо, форму которого необходимо открыть
//  НаименованиеРеквизита - Строка - параметр позволяет определить, какой на каком элементе формы физического лица
//		необходимо спозиционировать курсор. В самой функции каждому значению данного параметра определен соотвествующей элемент формы физического лица
//		Возможные варианты значений параметра:
//			СНИЛС
//			ФИО
//
Процедура ОткрытьФормуВладельцаЭЦПНаРеквизите(ВладелецЭЦП, НаименованиеРеквизита) Экспорт
	// Определяем соотвествие имен реквизитов мастера и имен реквизитов формы организации
	СоответствиеИмен = Новый Структура(); 
	
	//СоответствиеИмен.Вставить(<имя поля мастера>, <Имя элемента управления формы владельца ЭЦП>)
	СоответствиеИмен.Вставить("СНИЛС", "СтраховойНомерПФР");
	
	СоответствиеИмен.Вставить("ФИО",   "Фамилия");
	
	ИмяРеквизитаФормы = "";
	СоответствиеИмен.Свойство(НаименованиеРеквизита,ИмяРеквизитаФормы);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", ВладелецЭЦП);
	
	Если ТипЗнч(ВладелецЭЦП) = Тип("СправочникСсылка.Организации") Тогда
		Форма = ПолучитьФорму("Справочник.Организации.Форма.ФормаЭлемента", ПараметрыФормы);
	Иначе
		Форма = ПолучитьФорму("Справочник.Сотрудники.Форма.ФормаЭлемента", ПараметрыФормы);
	КонецЕсли;
	
	Если Форма.Элементы.Найти(ИмяРеквизитаФормы)<> Неопределено Тогда 
		Форма.ТекущийЭлемент = Форма.Элементы[ИмяРеквизитаФормы];
	КонецЕсли;
	Форма.Открыть();
	
КонецПроцедуры

// Открывает форму Главного бухгалтера организации
// 
// 
// Параметры:
//  СправочникСсылка.Организации - организация, форму главного бухгалтера которой нужно открыть
//
Процедура ОткрытьФормуГлБухгалтера(Организация) Экспорт
	
	ОтветственноеЛицо	= ПредопределенноеЗначение("Перечисление.ТипыОтветственныхЛиц.ГлавныйБухгалтер");
	
	ЗначенияЗаполнения	= Новый Структура("Организация,ТипОтветственногоЛица",
		Организация,
		ОтветственноеЛицо);
		
	РуководительКлючЗаписи = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ПолучитьКлючЗаписиРегистраОтветственныеЛицаОрганизаций(Организация,ОтветственноеЛицо);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",					РуководительКлючЗаписи);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения",	ЗначенияЗаполнения);
	
	ОткрытьФорму("РегистрСведений.ОтветственныеЛица.ФормаЗаписи", ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму Организации, позиционируясь том элементе формы, который нужно изменить из мастера подключения к 1С-Отчетности
//
//
// Параметры:
//  Организация - СправочникСсылка.Организации  - организация, у которой необходимо поменять значение реквизита из мастера
//  НаименованиеРеквизита - Строка - параметр позволяет определить, какой на каком элементе формы организации необходимо спозиционировать курсор.
//		В самой функции каждому значению данного параметра определен соотвествующей элемент формы Организации
//		Возможные варианты значений параметра:
//			КраткоеНаименование
//			ПолноеНаименование
//			ИНН
//			КПП
//			РегНомерПФР
//			РегНомерФСС
//			ДополнительныйКодФСС
//			ОГРН
//
Процедура ОткрытьФормуОрганизацииНаРеквизите(Организация,НаименованиеРеквизита) Экспорт
	
	// Определяем соотвествие имен реквизитов мастера и имен реквизитов формы организации
	СоответствиеИмен = Новый Структура(); 
	
	//СоответствиеИмен.Вставить(<имя поля мастера>, 	<Имя элемента управления формы организации>)
	СоответствиеИмен.Вставить("КраткоеНаименование",	"Наименование");
	СоответствиеИмен.Вставить("ПолноеНаименование", 	"НаименованиеПолное");
	СоответствиеИмен.Вставить("ИНН",				 	"ИНН");
	СоответствиеИмен.Вставить("КПП",				 	"КПП");
	СоответствиеИмен.Вставить("РегНомерПФР",		 	"РегистрационныйНомерПФР");
	СоответствиеИмен.Вставить("РегНомерФСС",		 	"РегистрационныйНомерФСС");
	СоответствиеИмен.Вставить("ОГРН",					"ОГРН");
	
	ИмяРеквизитаФормы = "";
	СоответствиеИмен.Свойство(НаименованиеРеквизита,ИмяРеквизитаФормы);	
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", Организация);
	
	ФормаОрганизации = ПолучитьФорму("Справочник.Организации.Форма.ФормаЭлемента", ПараметрыФормы);
	Если ФормаОрганизации.Элементы.Найти(ИмяРеквизитаФормы)<> Неопределено Тогда 
		ФормаОрганизации.ТекущийЭлемент = ФормаОрганизации.Элементы[ИмяРеквизитаФормы];
	КонецЕсли;
	Если ФормаОрганизации.Открыта() Тогда
		ФормаОрганизации.Активизировать();
	Иначе
		ФормаОрганизации.Открыть();
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму Руководителя организации
// 
// 
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, форму руководителя которой нужно открыть
//
Процедура ОткрытьФормуРуководителя(Организация) Экспорт
	
	ОтветственноеЛицо	= ПредопределенноеЗначение("Перечисление.ТипыОтветственныхЛиц.Руководитель");
	
	ЗначенияЗаполнения	= Новый Структура("Организация,ОтветственноеЛицо",
		Организация,
		ОтветственноеЛицо);
		
	РуководительКлючЗаписи = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ПолучитьКлючЗаписиРегистраОтветственныеЛицаОрганизаций(Организация,ОтветственноеЛицо); 	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",					РуководительКлючЗаписи);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения",	ЗначенияЗаполнения);
	
	ОткрытьФорму("РегистрСведений.ОтветственныеЛица.ФормаЗаписи", ПараметрыФормы);
	
КонецПроцедуры

// Возвращает список из 4х ссылок на статьи по 1С-Отчетности 
//
//
// Параметры:
//  Отсутсвуют
//
// Возвращаемое значение:
//  СписокЗначений - cписок из 4х ссылок на статьи. Значение элемента списка - URL-адрес на статью по 1С-Отчетности, 
//		представление элемента списка - пользовательское наименование статьи.
//  	Каждая статья содержит информацию о порядке предоставления отчетности в соотвествующий орган
//
Функция СписокСсылокНаСтатьиПо1СОтчетности() Экспорт
	
	СписокСсылок = Новый СписокЗначений;
	СписокСсылок.Добавить("http://its.1c.ru/db/elreps#content:10:1","Отчетность в налоговые органы и Росстат");
	СписокСсылок.Добавить("http://its.1c.ru/db/elreps#content:18:1","Отчетность в ПФР");
	СписокСсылок.Добавить("http://its.1c.ru/db/elreps#content:14:1","Отчетность в ФСС");
	
	Возврат СписокСсылок;
КонецФункции

// Возвращает строку - путь к основной форме организации
//
//
// Параметры:
//  Отсутсвуют
//
// Возвращаемое значение:
//  Строка - путь к основной форме справочника организации. Строка вида "Справочник.Организации.Форма.<ИмяФормы>"
//
Функция ПутьКОсновнойФормеСправочникаОрганизации() Экспорт
	Возврат "Справочник.Организации.Форма.ФормаЭлемента";
КонецФункции
	
// Возвращает имя события, с которым будет срабатывать оповещение для показа истории отправки в контролирующие органы
// документа или элемента справочника в журнале обмена
//
// Параметры
//   Источник  - СправочникСсылка, ДокументСсылка,  - документ или элемент справочника, отправляемый в контролируемые органы
//
// Возвращаемое значение:
//   Строка   - имя события, может принимать одно из следущих значений:
//		- "Показать циклы обмена уведомления", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке ФНС, страница Исходящие уведомления   
//		- "Показать циклы обмена отчета ПФР", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке ПФР, страница Отчетность   
//		- "Показать циклы обмена отчета статистики", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке Росстат, страница Отчетность
//		- "Показать циклы обмена", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке ФНС, страница Отчетность
//		- "Показать циклы обмена заявления", если необходимо открыть форму 
//				Обработки.ДокументооборотСКонтролирующимиОрганами.Формы.УправлениеОбменом на закладке ФНС, страница Заявления о ввозе товаров
//
Функция ИмяСобытияОткрытияИсторииОтправки(Источник) Экспорт

КонецФункции 
	
// Процедура предназначена для выбора пользователем физического лица из списка физических лиц.
// При этом, из списка убираются сотрудники, являющиеся ответственными лицами у переданной организации.
// В списке физических лиц курсор устанавливается на том физ лице, которое передано в качестве параметра.
//
// Параметры
//  Организация  - <Справочники.Организации> - Организация, к уоторой будет выполнен поиск ответственных лиц
//  ВладелецЭЦП  - <Справочники.ФизическиеЛица> - физическое лицо, на котором нужно спозиционироваться в списке физических лиц.
//		Если ВладелецЭЦП = Неопределено, то позиционироваться на физ лице не нужно
//  ВыполняемоеОповещение - <ОписаниеОповещения> - Оповещение, которое будет выполнено после выбора физического лица, результатом,
//		которого является выбранное физическое лицо
//
Процедура ПолучитьИсполнителя(Организация, ВладелецЭЦП, ВыполняемоеОповещение) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	// Показываем физ лица, которые не являются ответственными лицами
	ОтветственныеЛицаОрганизации = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ПолучитьДанныеОтветственныхЛиц(Организация);
	Если НЕ ОтветственныеЛицаОрганизации = Неопределено Тогда
		
		ФН = Новый НастройкиКомпоновкиДанных;
		
		Эл = ФН.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Эл.ЛевоеЗначение	= Новый ПолеКомпоновкиДанных("Ссылка");
		Эл.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеВСписке;
		Эл.ПравоеЗначение	= ОтветственныеЛицаОрганизации;
		Эл.Использование	= Истина;
		
		ПараметрыФормы.Вставить("ФиксированныеНастройки", ФН)
	КонецЕсли;
	
	// Если уже был выбран владелец ЭЦП, то позиционироваться в списке на нем
	Если ЗначениеЗаполнено(ВладелецЭЦП) Тогда
		ПараметрыФормы.Вставить("ТекущаяСтрока", ВладелецЭЦП);
	КонецЕсли;
	
	// Открытие формы
	Если ОтветственныеЛицаОрганизации = Неопределено И ВладелецЭЦП = Неопределено Тогда
		ОткрытьФорму("Справочник.Сотрудники.ФормаВыбора", Новый Структура("РежимВыбора", Истина),,,,,ВыполняемоеОповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ОткрытьФорму("Справочник.Сотрудники.ФормаВыбора", ПараметрыФормы,,,,,ВыполняемоеОповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

// Функция определяет, доступна ли для текущего пользователя возможность интерактивного редактирования 
// поля СНИЛС в карточке Физ лица, которое передано в качестве параметра функции 
// с учетом всех прав, функциональных опции и прочих ограничений
//
// Параметры
//  ФизЛицо  - Справочники.ФизическиеЛица - Физичекое лицо, для которого определяется возможность редактирования СНИЛСа
//
// Возвращаемое значение:
//   Булево   - Истина, если интерактирвное редактирование возможно, Ложь - в противном случае
//
Функция СНИЛСДоступенДляРедактирования(ФизЛицо) Экспорт
	Возврат Истина;
КонецФункции
	
// Процедура выполняет отправку документа или отчета в контролирующий орган
//
// Параметры
//  Ссылка  					- СправочникСсылка, ДокументСсылка - Документ или элемент справочника, который отправляется в контролирующий орган
//  ВидКонтролирующегоОргана  - Перечисление.ТипыКонтролирующихОрганов - Вид контролирующего Органа, в который выполняется отправка
//  КодКонтролирующегоОргана  - Строка - Код контролирующего органа, в который выполняется отправка
//  СтандартнаяОбработка  - Булево - Определяет, должна ли выполняться стандартная отправка в контролирующий орган или отправка должна быть переопределена. 
// 		Если СтандартнаяОбработка = Ложь, то будет выполняться отправка в данной процедуре, а стандартная отправка выполняться не будет
//
Процедура ОтправитьВКонтролирующийОрган(Ссылка, ВидКонтролирующегоОргана, КодКонтролирующегоОргана, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Процедура выполняет проверку в интернете документа или отчета
//
// Параметры
//  Ссылка  - СправочникСсылка, ДокументСсылка - Документ или элемент справочника, который проверяется в интернете
//  СтандартнаяОбработка  - Булево - Определяет, должна ли выполняться стандартная проверка в интернете или проверка должна быть переопределена. 
// 		Если СтандартнаяОбработка = Ложь, то будет выполняться проверка в данной процедуре, а стандартная проверка в интернете выполняться не будет
//
Процедура ПроверитьВИнтернете(Ссылка, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Процедура показывает форму состояния отправки для объекта, отправляемого в контролирующие органы
//
// Параметры
//  Ссылка  - СправочникСсылка, ДокументСсылка - Документ или элемент справочника, для которого будет отображено состояние отправки
//  СтандартнаяОбработка  - Булево - Определяет, должна ли отображаться форма состояния отправки, входящая в БРО или нет
// 		Если СтандартнаяОбработка = Ложь, то форма, входящая в БРО отображаться не будет
//
Процедура ПоказатьСостояниеОтправкиОтчета(Ссылка, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#Область ДокументыПоТребованиюФНС

// Заполняется при наличии в конфигурации документов библиотеки БРУ:
// Открывает форму выбора документов НДС, в качестве описания оповещения при открытии формы выбора используется ОписаниеОповещения, передаваемое в параметрах процедуры.
//
// Параметры процедуры: 
//	(обязательный) ОписаниеОповещения	- ОписаниеОповещения
//	(необязательный) ПараметрыОтбора	- Структура, задает начальные значения отборов. 
//		Поля структуры:
// 			(необязательный) Организация	- СправочникСсылка.Организации
// Пример:
// УчетНДСКлиент.ВыбратьДокументНДСДляПередачиФНС(ОписаниеОповещения, ПараметрыОтбора);
//
Процедура ВыбратьДокументНДСДляПередачиФНС(ОписаниеОповещения, ПараметрыОтбора = Неопределено) Экспорт 
	
КонецПроцедуры

// Заполняется при наличии в конфигурации библиотеки БЭД:
//
// Параметры:
//  ДокументИБСсылка - ссылка на документ ИБ;
//
// Пример:
// ЭлектронныеДокументыКлиент.ОткрытьАктуальныйЭД(ДокументИБСсылка);
//
Процедура ОткрытьАктуальныйЭД(ДокументИБСсылка) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Заполняется при наличии в конфигурации библиотеки БЭД:
// Открывает форму подключения к сервису электронных документов
//
// Параметры:
//  ОрганизацияСсылка - СправочникСсылка.Организации
//  ДополнительныеПараметры - структура
//
// Пример для версии БЭД 1.2.6 и ниже:
//	ЭлектронныеДокументыКлиент.ПредложениеОформитьЗаявлениеНаПодключение(Неопределено, ОрганизацияСсылка);
//
// Пример для версии БЭД 1.2.7 и выше:
//	ЭлектронныеДокументыКлиент.ПредложениеОформитьЗаявлениеНаПодключение(Неопределено, ОрганизацияСсылка, ДополнительныеПараметры);
//
Процедура ОткрытьФормуПодключенияКСервисуЭлектронныхДокументов(ОрганизацияСсылка, ДополнительныеПараметры, ВыполняемоеОповещение) Экспорт
	ОбменСКонтрагентамиКлиент.ПредложениеОформитьЗаявлениеНаПодключение(Неопределено, ОрганизацияСсылка, ДополнительныеПараметры, ВыполняемоеОповещение);
КонецПроцедуры