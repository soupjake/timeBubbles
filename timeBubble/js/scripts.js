var w = window.innerWidth * 0.8;
var h = window.innerHeight * 0.8;
var oR = 0;
var nTop = 0;

//data object made for selecting data
var data = {};

d3.queue()
	.defer(d3.json, "json/data1.json")
	.defer(d3.json, "json/data2.json")
	.defer(d3.json, "json/data3.json")
	.defer(d3.json, "json/data4.json")
	.defer(d3.json, "json/data5.json")
	.defer(d3.json, "json/data6.json")
	.await(function(error, d1, d2, d3, d4, d5, d6) {
		data['1'] = d1;
		data['2'] = d2;
		data['3'] = d3;
		data['4'] = d4;
		data['5'] = d5;
		data['6'] = d6;
		draw('1');
	});

var svg = d3.select("#mainBubble").append("svg")
	.attr("height", h)
	.attr("width", w)
	.style("margin", "auto")
    .on("mouseleave", function() {
        return resetBubbles();
    });
		
var colors = ["#9E5AC4", "#FF6D6D", "#5DCF87", "#5D80C3"];
var subcolors = ["#DAB4EF", "#FDB8B8", "#88F3CE", "#B4C8EF"];
	
var slider = d3.select('#date');
slider.on('change', function() {
	dateSelected = this.value;
	svg.selectAll(".childBubble").transition()
		.duration(500)
		.style("opacity", 0)
		.remove();
	svg.selectAll(".childBubbleText").remove();
	updateDate(parseInt(dateSelected));
	draw(dateSelected)
});

function draw(date){
	
	var root = data[date];
	
    var bubbleObj = svg.selectAll(".topBubble")
        .data(root.children)
        .enter()
		.append("g");

    console.log(root);
    nTop = root.children.length;
    oR = w / (1 + 3 * nTop);

    h = Math.ceil(w / nTop * 2.5);

    bubbleObj.append("circle")
        .attr("class", "topBubble")
        .attr("id", function(d, i) {
            return "topBubble" + i;
        })
        .attr("r", function(d) {
            return oR;
        })
        .attr("cx", function(d, i) {
            return oR * (3 * (1 + i) - 1);
        })
        .attr("cy", (h + oR) / 3)
        .style("fill", function(d, i) {
            return colors[i];
        })
        .style("opacity", 1)
        .on("mouseover", function(d, i) {
            return activateBubble(d, i);
        });


    bubbleObj.append("text")
        .attr("class", "topBubbleText")
        .attr("x", function(d, i) {
            return oR * (3 * (1 + i) - 1);
        })
        .attr("y", function(){
			if (document.documentMode || /Edge/.test(navigator.userAgent))
				return ((h + oR) / 2.9);
			else
				return ((h + oR) / 3);
		})
        .style("fill", "#ffffff") // #1f77b4
        .attr("font-size", 30)
        .attr("text-anchor", "middle")
        .attr("dominant-baseline", "middle")
        .attr("alignment-baseline", "middle")
        .text(function(d) {
			return d.name;
        })
        .on("mouseover", function(d, i) {
            return activateBubble(d, i);
        });

    for (var iB = 0; iB < nTop; iB++) {
        var childBubbles = svg.selectAll(".childBubble" + iB)
            .data(root.children[iB].children)
            .enter().append("g");

        childBubbles.append("circle")
            .attr("class", "childBubble")
            .attr("id", "childBubble" + iB)
            .attr("r", function(d) {
                return oR / 3.0;
            })
            .attr("cx", function(d, i) {
                return (oR * (3 * (iB + 1) - 1) + oR * 1.5 * Math.cos((i - 2) * 45 / 180 * 3.1415926));
            })
            .attr("cy", function(d, i) {
                return ((h + oR) / 3 + oR * 1.5 * Math.sin((i - 2) * 45 / 180 * 3.1415926));
            })
			.style("fill", function(d, i){
				return subcolors[iB];
			})
			.style("opacity", 0)
			.transition()
			.duration(500)
			.style("opacity", 0.5);

						
		childBubbles.append("text")
            .attr("class", "childBubbleText")
			.attr("id", "childBubbleText" + iB)
            .attr("x", function(d, i) {
                return (oR * (3 * (iB + 1) - 1) + oR * 1.5 * Math.cos((i - 2) * 45 / 180 * 3.1415926));
            })
            .attr("y", function(d, i) {
                return ((h + oR) / 3 + oR * 1.5 * Math.sin((i - 2) * 45 / 180 * 3.1415926));
            })
            .style("opacity", 0)
            .attr("text-anchor", "middle")
            .style("fill", function(d, i){
					return colors[iB];
			})
            .attr("font-size", 6)
			.attr("font-weight", "bold")
			.text(function(d) {
                return d.name;
            });
    }
};

resetBubbles = function() {	
    oR = w / (1 + 3 * nTop);
	
    var t = svg.transition()
        .duration(650);

    t.selectAll(".topBubble")
        .attr("r", function(d) {
            return oR;
        })
        .attr("cx", function(d, i) {
            return oR * (3 * (1 + i) - 1);
        })
        .attr("cy", (h + oR) / 3);

    t.selectAll(".topBubbleText")
        .attr("font-size", 30)
        .attr("x", function(d, i) {
            return oR * (3 * (1 + i) - 1);
        })
        .attr("y", function(){
			if (document.documentMode || /Edge/.test(navigator.userAgent))
				return ((h + oR) / 2.9);
			else
				return ((h + oR) / 3);
		})

    for (var k = 0; k < nTop; k++) {
        t.selectAll("#childBubbleText" + k)
            .attr("x", function(d, i) {
                return (oR * (3 * (k + 1) - 1) + oR * 1.5 * Math.cos((i - 2) * 45 / 180 * 3.1415926));
            })
            .attr("y", function(d, i) {
                return ((h + oR) / 3 + oR * 1.5 * Math.sin((i - 2) * 45 / 180 * 3.1415926));
            })
            .attr("font-size", 6)
            .style("opacity", 0);

        t.selectAll("#childBubble" + k)
            .attr("r", function(d) {
                return oR / 3.0;
            })
            .style("opacity", 0.5)
            .attr("cx", function(d, i) {
                return (oR * (3 * (k + 1) - 1) + oR * 1.5 * Math.cos((i - 2) * 45 / 180 * 3.1415926));
            })
            .attr("cy", function(d, i) {
                return ((h + oR) / 3 + oR * 1.5 * Math.sin((i - 2) * 45 / 180 * 3.1415926));
            });

    }
}


function activateBubble(d, i) {
    // increase this bubble and decrease others
    var t = svg.transition()
        .duration(d3.event.altKey ? 7500 : 350);

    t.selectAll(".topBubble")
        .attr("cx", function(d, ii) {
            if (i == ii) {
                // Nothing to change
                return oR * (3 * (1 + ii) - 1) - 0.6 * oR * (ii - 1);
            } else {
                // Push away a little bit
                if (ii < i) {
                    // left side
                    return oR * 0.6 * (3 * (1 + ii) - 1);
                } else {
                    // right side
                    return oR * (nTop * 3 + 1) - oR * 0.6 * (3 * (nTop - ii) - 1);
                }
            }
        })
        .attr("r", function(d, ii) {
			return (i == ii) ? oR * 1.8 : oR * 0.8;
        });

    t.selectAll(".topBubbleText")
        .attr("x", function(d, ii) {
            if (i == ii) {
                // Nothing to change
                return oR * (3 * (1 + ii) - 1) - 0.6 * oR * (ii - 1);
            } else {
                // Push away a little bit
                if (ii < i) {
                    // left side
                    return oR * 0.6 * (3 * (1 + ii) - 1);
                } else {
                    // right side
                    return oR * (nTop * 3 + 1) - oR * 0.6 * (3 * (nTop - ii) - 1);
                }
            }
        })
        .attr("font-size", function(d, ii) {
			return (i == ii) ? 45 + "px": 18 + "px"; 
        });
		
    var signSide = -1;
    for (var k = 0; k < nTop; k++) {
        signSide = 1;
        if (k < nTop / 2) signSide = 1;
        t.selectAll("#childBubbleText" + k)
		
            .attr("x", function(d, i) {
                return (oR * (3 * (k + 1) - 1) - 0.6 * oR * (k - 1) + signSide * oR * 2.5 * Math.cos((i - 2) * 45 / 180 * 3.1415926));
            })
            .attr("y", function(d, i) {
                return ((h + oR) / 3 + signSide * oR * 2.5 * Math.sin((i - 2) * 45 / 180 * 3.1415926));
            })
            .attr("font-size", function() {
                return (k == i) ? 12 + "px" : 6 + "px";
            })
            .style("opacity", function() {
                return (k == i) ? 1 : 0;
            });

        t.selectAll("#childBubble" + k)
            .attr("cx", function(d, i) {
                return (oR * (3 * (k + 1) - 1) - 0.6 * oR * (k - 1) + signSide * oR * 2.5 * Math.cos((i - 2) * 45 / 180 * 3.1415926));
            })
            .attr("cy", function(d, i) {
                return ((h + oR) / 3 + signSide * oR * 2.5 * Math.sin((i - 2) * 45 / 180 * 3.1415926));
            })
            .attr("r", function() {
                return (k == i) ? (oR * 0.5) : (oR / 3.0);
            })
            .style("opacity", function() {
                return (k == i) ? 1 : 0;
            });
    }
}

function updateDate(selected){
	switch(selected){
		case 1:
			d3.select("#selected_date")
				.text("Date 1")
				break;
		case 2:
			d3.select("#selected_date")
				.text("Date 2")
				break;
		case 3:
			d3.select("#selected_date")
				.text("Date 3")
				break;
		case 4:
			d3.select("#selected_date")
				.text("Date 4")
				break;
		case 5:
			d3.select("#selected_date")
				.text("Date 5")
				break;
		case 6:
			d3.select("#selected_date")
				.text("Date 6")
				break;
	}
}
