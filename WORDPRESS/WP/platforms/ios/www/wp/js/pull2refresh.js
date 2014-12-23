 var loadingContent= "<div id='infinite1' style='width:100%;height:30px;line-height:30px;'>正在加载...</div>";
function R_Pull2Refresh(panelSelector, listSelector, funcRefreshGetData, funcLoadGetData) {
//	this.panelSelector = panelSelector;
	this.funcRefreshGetData = funcRefreshGetData;
	this.funcLoadGetData = funcLoadGetData;
	
	this.listSelector = listSelector;
	var flagScroller = true;
	var scroller = null;
	var myObject = this;
	var refreshDom;
	var loadDom;
	//var refreshTimeout;
	//var loadTimeout;

//	this.funcCbNetResult = function () {
//		console.log("funcCbNetResult");
//		refreshDom.hideRefresh();
//	};
	this.cleanLoad = function() {
			if(loadDom){
				loadDom.clearInfinite();
				$(loadDom.el).find("#infinite1").remove();	
			}
	};
	this.onRefreshResult =  function(errCode, page,fragment){
			var container = $(myObject.listSelector);
		  if (errCode == 0 && container) {
				if (page == 1) {
					container.html(fragment);
				}
				else  {
					container.append(fragment);
				}											
			}
			flagScroller=true;	
			refreshDom.hideRefresh();			
			//clearTimeout(refreshTimeout);				
			myObject.cleanLoad();

			console.log("onRefreshResult");	
			
	};
	this.onLoadResult =  function(errCode, page,fragment){
			var container = $(myObject.listSelector);
		  if (errCode == 0 && container) {
				if (page == 1) {
					container.html(fragment);
				}
				else  {
					container.append(fragment);
				}		
								
			}
			flagScroller=true;		
						
		
			console.log("onLoadResult");		
			//clearTimeout(loadTimeout);	
			myObject.cleanLoad();
	};
	
	this.funcRefreshTimeOut = function () {
				console.log("hiding refresh TimeOut");
				refreshDom.hideRefresh();
				flagScroller=true;
	};
	
	this.funcLoadMoreTimeOut = function () {
				console.log("hiding loadMore timeout");
			 	
			 	flagScroller=true;
				myObject.cleanLoad();
	};
	this.funcRefresh2Trigger = function () {
					refreshDom = this;
			console.log("Refresh trigger");
			return true; 
	};	
	
	this.funcRefresh2Release = function () {
			refreshDom = this;
			console.log("Refresh release");
	
			if(flagScroller) {
				flagScroller=false;	
				//clearTimeout(refreshTimeout);
				//refreshTimeout = setTimeout(myObject.funcRefreshTimeOut, 10000);
				funcRefreshGetData(myObject.onRefreshResult);
				return true; 
				
			}
				
			return true; 
	};	
		
	this.funcInfiniteScroll = function() {
			var self = this;
			console.log("infinite triggered");
			/*上拉更新加载多次*/
			if($(self.el).find("#infinite1").length==0){
         	 $(self.el).append(loadingContent);
     	}
     	
     	$.bind(scroller, "infinite-scroll-end", 		myObject.funcInfiniteScrollEnd); 
     		
    };
     	
	this.funcInfiniteScrollEnd = function() {		
				var self = this;
				loadDom = this;
				$.unbind(scroller, "infinite-scroll-end");
				self.scrollToBottom();
				//$(self.el).find("#infinite1").remove();
				if(!flagScroller) return;
				flagScroller=false;
				//clearTimeout(loadTimeout);
				//loadTimeout = setTimeout(myObject.funcLoadMoreTimeOut, 10000);

				/*请求服务器加载数据*/
				funcLoadGetData(myObject.onLoadResult);										
		};	
	this.reset = function() {
		flagScroller=true;
		if (refreshDom) {	
			refreshDom.hideRefresh();		
		}
		myObject.cleanLoad();
	};
	
	this.doInit = function(onlyScrollUp) {
			scroller = $(panelSelector).scroller(); 
			scroller.addInfinite();
			if(!onlyScrollUp)
				scroller.addPullToRefresh();
			scroller.runCB=true;
			$.bind(scroller, "refresh-trigger", myObject.funcRefresh2Trigger);
			$.bind(scroller, "refresh-release", myObject.funcRefresh2Release);	
		  $.bind(scroller, "refresh-cancel", myObject.funcRefreshTimeOut);
      scroller.enable();              
		  /*上拉的时候触发的事件*/
		  $.bind(scroller, "infinite-scroll", myObject.funcInfiniteScroll );
			
	};


}


